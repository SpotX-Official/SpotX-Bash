#!/usr/bin/env bash

set -euo pipefail

clr='\033[0m'
green='\033[0;32m'
red='\033[0;31m'
yellow='\033[0;33m'

show_help() {
  echo -e \
"Usage: bash spotx-snap.sh [helper options] [SpotX-Bash options]

Helper options:
--allow-unverified    : allow an unverifiable snap set by '--snap-file'
--build-only          : create patched snap without installing
--channel <channel>   : select stable, candidate, beta, or edge with '--download'
--download            : download Spotify snap instead of using a local source
--help                : print this help message
--output-dir <path>   : set output directory for '--build-only'
--restore             : restore official store-managed Spotify snap
--snap-file <path>    : use a specific local Spotify snap
--uninstall           : same as '--restore'

All other supported options are passed to SpotX-Bash.
"
}

error() {
  echo -e "${red}Error:${clr} $*\n" >&2
  exit 1
}

latest_cached_snap() {
  local version="${1:-}" candidate latest=''
  for candidate in "${cacheDir}"/spotify_*.snap; do
    [[ -f "${candidate}" ]] || continue
    [[ -z "${version}" || "${candidate##*/}" == "spotify_${version}_"*.snap ]] || continue
    [[ -z "${latest}" || "${candidate}" -nt "${latest}" ]] && latest="${candidate}"
  done
  [[ -n "${latest}" ]] && printf '%s\n' "${latest}"
}

has_spotx_marker() {
  local spa="${1}" entry markerFile="${workDir}/marker.js"
  for entry in xpui.js xpui-snapshot.js; do
    "${sudoCmd[@]}" unzip -p "${spa}" "${entry}" > "${markerFile}" 2>/dev/null || true
    grep -Fq "//# SpotX was here" "${markerFile}" && return 0
  done
  return 1
}

verify_snap_source() {
  local snap="${1}" digest size assertion assertedDigest snapId assertedSize declaration declaredName candidate remoteAssertion
  digest=$("${sudoCmd[@]}" snap info --verbose "${snap}" 2>/dev/null | awk '$1 == "sha3-384:" { print $2; exit }')
  size=$("${sudoCmd[@]}" stat -c '%s' "${snap}")
  [[ -n "${digest}" ]] || return 1
  assertion=$(LC_ALL=C snap known snap-revision snap-sha3-384="${digest}" 2>/dev/null || true)
  [[ -n "${assertion}" ]] || {
    for candidate in "$(dirname -- "${sourceSnap}")"/*.assert; do
      [[ -f "${candidate}" ]] || continue
      "${sudoCmd[@]}" grep -Fqx "snap-sha3-384: ${digest}" "${candidate}" 2>/dev/null || continue
      "${sudoCmd[@]}" snap ack "${candidate}" >/dev/null 2>&1 || continue
      assertion=$(LC_ALL=C snap known snap-revision snap-sha3-384="${digest}" 2>/dev/null || true)
      [[ -n "${assertion}" ]] && break
    done
  }
  [[ -n "${assertion}" ]] || {
    remoteAssertion=$(LC_ALL=C timeout 20 snap known --remote snap-revision snap-sha3-384="${digest}" 2>/dev/null || true)
    [[ -n "${remoteAssertion}" ]] && {
      printf '%s\n' "${remoteAssertion}" > "${workDir}/snap-revision.assert"
      "${sudoCmd[@]}" snap ack "${workDir}/snap-revision.assert" >/dev/null 2>&1 || true
      assertion="${remoteAssertion}"
    }
  }
  [[ -n "${assertion}" ]] || return 1
  assertedDigest=$(awk '$1 == "snap-sha3-384:" { print $2; exit }' <<< "${assertion}")
  snapId=$(awk '$1 == "snap-id:" { print $2; exit }' <<< "${assertion}")
  assertedSize=$(awk '$1 == "snap-size:" { print $2; exit }' <<< "${assertion}")
  [[ "${assertedDigest}" == "${digest}" && -n "${snapId}" && "${assertedSize}" == "${size}" ]] || return 1
  declaration=$(LC_ALL=C snap known snap-declaration snap-id="${snapId}" 2>/dev/null || true)
  [[ -n "${declaration}" ]] || {
    remoteAssertion=$(LC_ALL=C timeout 20 snap known --remote snap-declaration snap-id="${snapId}" 2>/dev/null || true)
    [[ -n "${remoteAssertion}" ]] && {
      printf '%s\n' "${remoteAssertion}" > "${workDir}/snap-declaration.assert"
      "${sudoCmd[@]}" snap ack "${workDir}/snap-declaration.assert" >/dev/null 2>&1 || true
      declaration="${remoteAssertion}"
    }
  }
  declaredName=$(awk '$1 == "snap-name:" { print $2; exit }' <<< "${declaration}")
  [[ "${declaredName}" == "spotify" ]] || return 1
  sourceVerified='true'
}

cleanup() {
  [[ -n "${workDir:-}" && -d "${workDir}" && "${workDir}" == "${tempBase}/spotx-snap."* ]] && "${sudoCmd[@]}" rm -rf -- "${workDir}"
}

snapChannel='stable'
snapFile=''
allowUnverified=''
downloadSnap=''
buildOnly=''
restoreSnap=''
channelSet=''
outputSet=''
outputDir="${PWD}"
spotxArgs=()
while (($#)); do
  case "${1}" in
    --allow-unverified) allowUnverified='true' ;;
    --build-only) buildOnly='true' ;;
    --channel)
      (($# > 1)) || error "'--channel' requires an argument."
      snapChannel="${2}"
      channelSet='true'
      shift
      ;;
    --channel=*)
      snapChannel="${1#*=}"
      channelSet='true'
      ;;
    --download) downloadSnap='true' ;;
    --help) show_help; exit 0 ;;
    --output-dir)
      (($# > 1)) || error "'--output-dir' requires an argument."
      outputDir="${2}"
      outputSet='true'
      shift
      ;;
    --output-dir=*)
      outputDir="${1#*=}"
      outputSet='true'
      ;;
    --restore|--uninstall) restoreSnap='true' ;;
    --snap-file)
      (($# > 1)) || error "'--snap-file' requires an argument."
      snapFile="${2}"
      shift
      ;;
    --snap-file=*) snapFile="${1#*=}" ;;
    -P*|-F*|--installdeb|--installmac|--rollback|--stable)
      error "'${1}' cannot be used with spotx-snap.sh."
      ;;
    -c|--clearcache)
      error "Snap cache clearing is not supported by spotx-snap.sh."
      ;;
    -v|--version|--logo)
      error "'${1}' does not patch a snap and cannot be used with spotx-snap.sh."
      ;;
    --) error "'--' is not supported by spotx-snap.sh." ;;
    *) spotxArgs+=("${1}") ;;
  esac
  shift
done

[[ "$(uname -s)" == "Linux" ]] || error "spotx-snap.sh requires Linux."
[[ "$(uname -m)" == "x86_64" || "$(uname -m)" == "amd64" ]] || error "Spotify snap requires an x86_64 Linux system."
[[ -z "${allowUnverified}" || -n "${snapFile}" ]] || error "'--allow-unverified' requires '--snap-file'."
[[ -z "${snapFile}" || -z "${downloadSnap}" ]] || error "'--snap-file' and '--download' cannot be used together."
[[ -z "${channelSet}" || -n "${downloadSnap}" ]] || error "'--channel' requires '--download'."
[[ -z "${outputSet}" || -n "${buildOnly}" ]] || error "'--output-dir' requires '--build-only'."
[[ "${restoreSnap}" ]] && {
  [[ -z "${snapFile}${downloadSnap}${buildOnly}${channelSet}${outputSet}" && ${#spotxArgs[@]} -eq 0 ]] || error "'--restore' cannot be combined with other options."
}
[[ "${snapChannel}" =~ ^(stable|candidate|beta|edge)$ ]] || error "Invalid snap channel '${snapChannel}'."

scriptDir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
spotxScript="${scriptDir}/spotx.sh"
[[ -f "${spotxScript}" ]] || error "spotx.sh not found beside spotx-snap.sh."

for requirement in snap unsquashfs unzip zip perl awk grep sha256sum mktemp getent install stat timeout; do
  command -v "${requirement}" >/dev/null || error "${requirement} command not found."
done

runUser="${SUDO_USER:-$(id -un)}"
runUid=$(id -u "${runUser}")
runGid=$(id -g "${runUser}")
runHome=$(getent passwd "${runUser}" 2>/dev/null | awk -F: 'NR == 1 { print $6 }')
[[ -n "${runHome}" ]] || runHome="${HOME}"
cacheBase="${runHome}/.cache/spotx-bash"
cacheDir="${cacheBase}/snap"
sudoCmd=()
((EUID == 0)) || {
  command -v sudo >/dev/null || error "sudo command not found."
  sudo -n true >/dev/null 2>&1 || {
    echo -e "This script requires sudo permission to preserve and install snap files.\nPlease enter your sudo password..."
    sudo -v || error "Failed to obtain sudo permission."
  }
  sudoCmd=(sudo)
}

snap version >/dev/null 2>&1 || error "snapd is not available."
[[ "${restoreSnap}" ]] && {
  LC_ALL=C snap list spotify >/dev/null 2>&1 || error "Spotify snap is not installed."
  command pkill -9 '[sS]potify' 2>/dev/null || true
  echo -e "Restoring official store-managed Spotify snap...\n"
  "${sudoCmd[@]}" snap refresh --amend --channel=latest/stable spotify || error "Official Spotify snap restore failed."
  echo
  echo -e "${green}Finished${clr}\n"
  exit 0
}

tempBase="${TMPDIR:-/tmp}"
tempBase="${tempBase%/}"
workDir=$(mktemp -d "${tempBase}/spotx-snap.XXXXXXXX")
trap cleanup EXIT
trap 'exit 130' HUP INT TERM
sourceDir="${workDir}/source"
snapRoot="${workDir}/squashfs-root"
packedDir="${workDir}/packed"
sourceCopy="${sourceDir}/spotify.snap"
mkdir -p "${sourceDir}" "${packedDir}"

sourceSnap=''
sourceOutput=''
[[ -n "${snapFile}" ]] && {
  [[ -f "${snapFile}" ]] || error "Snap file not found: ${snapFile}"
  sourceSnap=$(cd -- "$(dirname -- "${snapFile}")" && pwd)/$(basename -- "${snapFile}")
  sourceOutput="${sourceSnap}"
}
[[ "${downloadSnap}" ]] && {
  downloadDir="${workDir}/download"
  mkdir -p "${downloadDir}"
  echo -e "Downloading Spotify snap from ${snapChannel} channel...\n"
  downloadOutput=$(cd "${downloadDir}" && snap download spotify --channel="${snapChannel}" 2>&1) || {
    echo -e "${downloadOutput}\n" >&2
    error "Spotify snap download failed."
  }
  for candidate in "${downloadDir}"/spotify_*.snap; do
    [[ -f "${candidate}" ]] || continue
    [[ -z "${sourceSnap}" ]] || error "Multiple Spotify snap downloads found."
    sourceSnap="${candidate}"
  done
  [[ -n "${sourceSnap}" ]] || error "Spotify snap download not found."
  sourceOutput="downloaded ${snapChannel} snap"
}
[[ -z "${sourceSnap}" ]] && {
  installedOutput=$(LC_ALL=C snap list spotify 2>/dev/null || true)
  installedVersion=$(awk 'NR == 2 { print $2 }' <<< "${installedOutput}")
  installedRev=$(awk 'NR == 2 { print $3 }' <<< "${installedOutput}")
  [[ -n "${installedRev}" && "${installedRev}" != x* ]] && {
    installedSnap="/var/lib/snapd/snaps/spotify_${installedRev}.snap"
    [[ -f "${installedSnap}" ]] && {
      sourceSnap="${installedSnap}"
      sourceOutput="installed Spotify snap revision ${installedRev}"
    }
  }
}
[[ -z "${sourceSnap}" ]] && {
  installedCacheVersion=''
  [[ -n "${installedVersion:-}" ]] && installedCacheVersion=$(printf '%s' "${installedVersion}" | tr -c 'A-Za-z0-9._-' '_')
  cachedSnap=$(latest_cached_snap "${installedCacheVersion}" || true)
  [[ -n "${cachedSnap}" ]] && {
    sourceSnap="${cachedSnap}"
    sourceOutput="cached original snap"
  }
  [[ -z "${cachedSnap}" && -n "${installedVersion:-}" ]] && error "No cached original found for installed Spotify ${installedVersion}.\nUse '--snap-file <path>' or '--download'."
}
[[ -n "${sourceSnap}" ]] || error "No unmodified Spotify snap source found.\nUse '--snap-file <path>' or '--download'."

echo -e "Using ${sourceOutput}\n"
"${sudoCmd[@]}" cp -p -- "${sourceSnap}" "${sourceCopy}"
sourceVerified=''
verify_snap_source "${sourceCopy}" && {
  echo -e "${green}Verified official Spotify snap${clr}\n"
} || {
  [[ "${allowUnverified}" ]] || error "Selected snap could not be authenticated as an official Spotify snap.\nConnect to the internet, place its matching assertion beside it or use '--allow-unverified'."
  echo -e "${yellow}Warning:${clr} Selected snap could not be authenticated and will not be cached.\n"
}
"${sudoCmd[@]}" unsquashfs -d "${snapRoot}" "${sourceCopy}" >/dev/null
spotifyPath="${snapRoot}/usr/share/spotify"
xpuiSpa="${spotifyPath}/Apps/xpui.spa"
snapYaml="${snapRoot}/meta/snap.yaml"
[[ -f "${xpuiSpa}" && -f "${spotifyPath}/spotify" ]] || error "Spotify client not found inside snap."
[[ -f "${snapYaml}" ]] || error "Snap metadata not found."
snapName=$("${sudoCmd[@]}" awk '$1 == "name:" { print $2; exit }' "${snapYaml}")
snapName="${snapName#\"}"
snapName="${snapName%\"}"
snapName="${snapName#\'}"
snapName="${snapName%\'}"
[[ "${snapName}" == "spotify" ]] || error "Selected snap is not the Spotify snap."
has_spotx_marker "${xpuiSpa}" && error "Selected snap source is already patched.\nUse an original snap file or '--download'."

snapVersion=$("${sudoCmd[@]}" awk '$1 == "version:" { print $2; exit }' "${snapYaml}")
snapVersion="${snapVersion#\"}"
snapVersion="${snapVersion%\"}"
snapVersion="${snapVersion#\'}"
snapVersion="${snapVersion%\'}"
[[ -n "${snapVersion}" ]] || error "Unable to determine Spotify snap version."
forcedVersion="${snapVersion%%.g*}"
safeVersion=$(printf '%s' "${snapVersion}" | tr -c 'A-Za-z0-9._-' '_')
sourceHash=$("${sudoCmd[@]}" sha256sum "${sourceCopy}" | awk '{ print $1 }')
cacheFile="${cacheDir}/spotify_${safeVersion}_${sourceHash:0:12}.snap"
[[ "${sourceVerified}" ]] && {
  "${sudoCmd[@]}" install -d -o "${runUid}" -g "${runGid}" -m 0755 "${cacheBase}" "${cacheDir}"
  [[ -f "${cacheFile}" ]] || {
    "${sudoCmd[@]}" install -o "${runUid}" -g "${runGid}" -m 0644 "${sourceCopy}" "${cacheFile}"
    echo -e "Cached original snap: ${cacheFile}\n"
  }
}

echo -e "Patching Spotify ${forcedVersion} with SpotX-Bash...\n"
"${sudoCmd[@]}" env SPOTX_BUILD_MODE=true bash "${spotxScript}" -P "${spotifyPath}" -F "${forcedVersion}" "${spotxArgs[@]}"
"${sudoCmd[@]}" rm -f -- "${spotifyPath}/spotify.bak" "${spotifyPath}/Apps/xpui.bak"
"${sudoCmd[@]}" unzip -tqq "${xpuiSpa}" || error "Patched xpui.spa validation failed."
has_spotx_marker "${xpuiSpa}" || error "SpotX marker not found in patched xpui.spa."

echo -e "Packing patched Spotify snap...\n"
"${sudoCmd[@]}" snap pack "${snapRoot}" "${packedDir}" >/dev/null
packedSnap=''
for candidate in "${packedDir}"/*.snap; do
  [[ -f "${candidate}" ]] || continue
  [[ -z "${packedSnap}" ]] || error "Multiple packed snap files found."
  packedSnap="${candidate}"
done
[[ -n "${packedSnap}" ]] || error "Patched snap was not created."
"${sudoCmd[@]}" unsquashfs -s "${packedSnap}" >/dev/null || error "Patched snap validation failed."

outputName="Spotify.v${forcedVersion}.Linux.x64-SPOTX.snap"
[[ "${buildOnly}" ]] && {
  mkdir -p "${outputDir}"
  outputDir=$(cd -- "${outputDir}" && pwd)
  outputFile="${outputDir}/${outputName}"
  [[ ! -e "${outputFile}" ]] || error "Output file already exists: ${outputFile}"
  "${sudoCmd[@]}" install -o "${runUid}" -g "${runGid}" -m 0644 "${packedSnap}" "${outputFile}"
  echo -e "${green}Created:${clr} ${outputFile}\n"
  exit 0
}

command pkill -9 '[sS]potify' 2>/dev/null || true
echo -e "${yellow}Warning:${clr} This locally installed snap will not receive automatic Spotify updates."
echo -e "Re-run this helper to update it or use '--restore' to return to the official snap.\n"
echo -e "Installing patched Spotify snap...\n"
"${sudoCmd[@]}" snap install --dangerous "${packedSnap}"
installedOutput=$(LC_ALL=C snap list spotify 2>/dev/null || true)
installedVersion=$(awk 'NR == 2 { print $2 }' <<< "${installedOutput}")
[[ -n "${installedVersion}" ]] || error "Spotify snap installation could not be verified."
echo -e "\n${green}Installed:${clr} Spotify ${installedVersion} with SpotX-Bash"
echo -e "Re-run this helper to rebuild from the cached original snap."
echo -e "Restore the official snap with: ${yellow}bash spotx-snap.sh --restore${clr}\n"
exit 0
