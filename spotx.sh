#!/usr/bin/env bash

buildVer="1.2.98.301.gfcaeba72"
rollbackVer="1.2.97.270.ge94a76a2"

latestB_X="4419"
latestB_A="4419"
rollbackB_X="4199"
rollbackB_A="4199"

clr='\033[0m'
green='\033[0;32m'
red='\033[0;31m'
yellow='\033[0;33m'

command -v perl >/dev/null || { echo -e "\n${red}Error:${clr} perl command not found.\nInstall perl on your system then try again.\n" >&2; exit 1; }

case $(uname | tr '[:upper:]' '[:lower:]') in
  darwin*) platformType='macOS' ;;
        *) platformType='Linux' ;;
esac

show_help() {
  echo -e \
"Options:
-B, --blockupdates     : block client auto-updates [macOS]
-c, --clearcache       : clear client app cache
-d, --devmode          : enable developer mode
-e, --noexp            : exclude all experimental features
-f, --force            : force SpotX-Bash to run
-h, --hide             : hide non-music on home screen
--help                 : print this help message
-i, --interactive      : enable interactive mode
--installdeb           : install latest client deb pkg on APT-based distros [Linux]
--installmac           : install latest supported client version [macOS]
-l, --lyricsbg         : set lyrics background color to black
--nocolor              : remove colors from SpotX-Bash output
-o, --oldui            : use old home screen UI
-p, --premium          : paid premium-tier subscriber
-P <path>              : set path to client
--rollback             : install previous supported client version [macOS]
-S, --skipcodesign     : skip codesigning [macOS]
--stable               : use with '--installdeb' for stable branch [Linux]
--uninstall            : uninstall SpotX-Bash
-v, --version          : print SpotX-Bash version
"
}

latestA_X=$(printf "%s" \
  "eyJpc3MiOiJzY2RuLXVybC1zaWduZXIiLCJleHAiOjE3OTAzMzkyODQsIm5iZiI6" \
  "MTc4Nzc0NzI4NCwicGF0aCI6Ii91cGdyYWRlL2NsaWVudC9vc3gteDg2XzY0L3Nw" \
  "b3RpZnktYXV0b3VwZGF0ZS0xLjIuOTguMzAxLmdmY2FlYmE3Mi00NDE5LnRieiJ9" \
  ".WFEoTMknXVdqEFEXFpwsh1dvPkJGgK2_nA2m_ZvPbJKy8dw500tWhJQQEjooiNn" \
  "MwO2kFinFLjIgk16DZE2u9lDPyYKYfGj5ydndnWGhSrVoA2bG0s0y5izfycTEQRm" \
  "NjYnlqekw7y6wQqHjw0fi613q7K3oguIh1B4Ns828MaHLPDH-QwKoaLSYqkQq87w" \
  "aVZ5B-0itesNFGhLGU1vTzFWXw47yNucfupca48cn3iTXQe2MFvBmG6MMFg8GRMu" \
  "b-wz9n0IaYJon3j9X-nDqj-scMLaHL6TELPlbchPEXsvd4LBKP53FKl8tZzQ4B7U" \
  "dibWdXqzVnkypJkSOdM895Q")
latestA_A=$(printf "%s" \
  "eyJpc3MiOiJzY2RuLXVybC1zaWduZXIiLCJleHAiOjE3OTAzMzkyODMsIm5iZiI6" \
  "MTc4Nzc0NzI4MywicGF0aCI6Ii91cGdyYWRlL2NsaWVudC9vc3gtYXJtNjQvc3Bv" \
  "dGlmeS1hdXRvdXBkYXRlLTEuMi45OC4zMDEuZ2ZjYWViYTcyLTQ0MTkudGJ6In0." \
  "c1rEwNAa-ZL7z17XMXf6a3wIHU8M-_QfpFdeG0QHg8UPcDJVNLJ2lQSX1RoZ_ifk" \
  "WVFY94XC1AWSAxbMHJbvHbdh0bWs8hbD9pyrd3JmMCKIFgDKZfV_dd_itjZ0hSMA" \
  "h_8yAKn6p_PlaAGB16GwToQ83h_-qo4elNtPjyzzlyV7IxkZYjEw5DhFQdQJtyzY" \
  "uMDcsjMtJnIcEes9_p8sM3G4S2PDruA1ReJjJn2G-mCfqLdKcERaN0crQ3aLS4u8" \
  "BtbeOEd_PAH-28HxFQLN1IdaMsXpL7-7axVdtQ00-fe-0HBUGRA50rhbnVmMhVIv" \
  "Dt4OGqBxFi0DNtKJS0ZREQ")
rollbackA_X=$(printf "%s" \
  "eyJpc3MiOiJzY2RuLXVybC1zaWduZXIiLCJleHAiOjE3OTAzMjQ4ODQsIm5iZiI6" \
  "MTc4NzczMjg4NCwicGF0aCI6Ii91cGdyYWRlL2NsaWVudC9vc3gteDg2XzY0L3Nw" \
  "b3RpZnktYXV0b3VwZGF0ZS0xLjIuOTcuMjcwLmdlOTRhNzZhMi00MTk5LnRieiJ9" \
  ".SicVpwADlCDQUW0Fgz0ryyWfsgYM9n5SxE-CyCtSlZ3rGovIQnuxzcZkBe7si2Y" \
  "Y_3AVCV4VfH3m_jOOpzzXaqjEffu8jrru9ppzjvHMxLlJ8qy0MXhEXJMcMN8-LqP" \
  "UbdM1O6iZM02tA8mIm4h83cv54ZkOV5K92MqLnESav0JyWqfJ6CD1-lQYfKH4Sr-" \
  "L9rLClCl94ZwvO3ZeQNneKDvWdKVQyDYIa2nXOv0kD3rmtXCMfmlaGNY6RedACg5" \
  "cjqqJZKp55q6ViTBTKguWbMwHvpuZY1K_AizIw79kmpVpBCONdVORpsGVM_2LRwI" \
  "fQB3XcdHgQuU3OiQQt58jCA")
rollbackA_A=$(printf "%s" \
  "eyJpc3MiOiJzY2RuLXVybC1zaWduZXIiLCJleHAiOjE3OTAzMjQ4ODQsIm5iZiI6" \
  "MTc4NzczMjg4NCwicGF0aCI6Ii91cGdyYWRlL2NsaWVudC9vc3gtYXJtNjQvc3Bv" \
  "dGlmeS1hdXRvdXBkYXRlLTEuMi45Ny4yNzAuZ2U5NGE3NmEyLTQxOTkudGJ6In0." \
  "lletfnnSbedV-U4k10nzQKEcBT_A2rnqeO-b7kdZFHU8PpUxcfJP66nu6A8mn7gy" \
  "eJcoxl8hsN2GnvNYQXOQM0kQeGYq1HVru88sCbpRuWZxFw5VKY3NdduQfFRjegzy" \
  "91JWHC7H4e_3Fn-YNMtp7uxBYfx3CFWVq-ZqZHGNUhyk750ODqQRIAXslpBZEjZO" \
  "vOrvdad8PdQDhloct9nQ_I7rmRs3kJSKBuwaxptya79W1Vcggb4LR9VoXg_lyO6C" \
  "PnZlJmyR3Bv43doNO7bA96U55iwAhHf2VweC4GynzpVE_88eBN7gpl5xTi97DpHA" \
  "0JaAVN3hpKj7oCuCBRwBMg")

while getopts ':BcdefF:hilopP:SvV:-:' flag; do
  case "${flag}" in
    -)
      case "${OPTARG}" in
        blockupdates) [[ "${platformType}" == "macOS" ]] && blockUpdates='true' ;;
        clearcache) clearCache='true' ;;
        debug) debug='true' ;;
        devmode) devMode='true' ;;
        force) forceSpotx='true' ;;
        help) show_help; exit 0 ;;
        hide) hideNonMusic='true' ;;
        installdeb) [[ "${platformType}" == "Linux" ]] && installDeb='true' ;;
        installmac) [[ "${platformType}" == "macOS" ]] && installMac='true' ;;
        interactive) interactiveMode='true' ;;
        logo) logoVar='true' ;;
        lyricsbg) lyricsBg='true' ;;
        nocolor) unset clr green red yellow ;;
        noexp) excludeExp='true' ;;
        oldui) oldUi='true' ;;
        premium) paidPremium='true' ;;
        rollback) [[ "${platformType}" == "macOS" ]] && { rollback='true'; installMac='true'; } ;;
        skipcodesign) [[ "${platformType}" == "macOS" ]] && skipCodesign='true' ;;
        stable) [[ "${platformType}" == "Linux" ]] && stableVar='true' ;;
        uninstall) uninstallSpotx='true' ;;
        version) verPrint='true' ;;
        $(date +"%y%d%m%H:%M")) t='true' ;;
        *) echo -e "${red}Error:${clr} '--""${OPTARG}""' not supported\n\n$(show_help)\n" >&2; exit 1 ;;
      esac ;;
    B) [[ "${platformType}" == "macOS" ]] && blockUpdates='true' ;;
    c) clearCache='true' ;;
    d) devMode='true' ;;
    e) excludeExp='true' ;;
    f) forceSpotx='true' ;;
    F) forceVer="${OPTARG}"; clientVer="${forceVer}" ;;
    h) hideNonMusic='true' ;;
    i) interactiveMode='true' ;;
    l) lyricsBg='true' ;;
    o) oldUi='true' ;;
    p) paidPremium='true' ;;
    P) p="${OPTARG}"; installPath="${p}"; installOutput=$(echo "${installPath}" | perl -pe 's|^$ENV{HOME}|~|') ;;
    S) [[ "${platformType}" == "macOS" ]] && skipCodesign='true' ;;
    v) verPrint='true' ;;
    V) echo -e "${red}Error:${clr} '-V' is no longer supported. Use '--installmac' for latest or '--rollback' for previous build.\n" >&2; exit 1 ;;
    \?) echo -e "${red}Error:${clr} '-""${OPTARG}""' not supported\n\n$(show_help)\n" >&2; exit 1 ;;
    :) echo -e "${red}Error:${clr} '-""${OPTARG}""' requires additional argument\n\n$(show_help)\n" >&2; exit 1 ;;
  esac
done

gVer=$(echo "==QP9EkW0VzUS5kUVFlRKFDT1x2VZRXOplld41WW2dmMjhmSVxUWSNjY35UMMNnRXFmas1mWtlTVMllUzI2dOFDT0ljMZVXSXR2bShVYulTeMZTTINGMShUY" | rev | base64 --decode | base64 --decode)
sxbLiveVer=$(printf "%s" \
  "=0zdHJWM1IDTyY1RaZHNq10ZjNlZnNnaJhXUpl0ZR5mYwpESjd2cU10aBNFUnF1Va9m" \
  "THRGaxckSnNHSJZnUHlUbZNUSwF1Va9mTHRGaxckSvF1VaVHbtpFbSdVSnlVaKdGOTt" \
  "kcwwmW0V0VPRXQ6dlb1MEWyF1RYV3dxs0a4xGTjR3QaNWNDhlcRdEWvhTeKdWVtJGd" \
  "BNkY5Z1Rjd2dIlUaw42YspVMadjUpl0Z3BzY0F0UjRXQDJWeWNTW" \
  | rev | base64 --decode | base64 --decode)
[[ "${SPOTX_BUILD_MODE}" ]] && sxbLive="${buildVer}" || sxbLive=$(eval "${sxbLiveVer}")
sxbVer=$(echo ${buildVer} | perl -ne '/(.*)\./ && print "$1"')
verCk=$(printf "%s" \
  "9QzRYNGayMGaKdUZwkzRjpXODplb1k3YwJ0QRdWVHJWaGdkYwZUbkhmQ5NGcCNl" \
  "Z5hnMZdjUplUOW1GZwh3aZRjTzU2aJNlZ1Z1ValHZyU2aBlmY2xmMjlnVtZVd4ZE" \
  "W1F1VaBjRHpFMWNjYn1EWhd2ZyMGaKVFTZJ1MidnTGlUb5cUS1lzVhpnSYplMCl3" \
  "Ywh2RWdGMuN2cOJTZr9meaVHbtJWeGJjV5Q2MiNHeXpVN0hkS" \
  | rev | base64 --decode | base64 --decode)
verCk2=$(eval echo "${verCk}")
ver() { echo "$@" | perl -lane 'printf "%d%03d%04d%05d\n", split(/\./, $_), (0)x4'; }
ver_check() { (($(ver "${sxbVer}") > $(ver "1.1.0.0") && $(ver "${sxbVer}") < $(ver "${sxbLive}"))) && echo -e "${verCk2}"; }
[[ "${verPrint}" ]] && { echo -e "SpotX-Bash version ${sxbVer}\n"; ver_check; exit 0; }

echo
echo "████╗███╗  ███╗ █████╗█╗  █╗  ███╗  ██╗ ████╗█╗ █╗"
echo "█╔══╝█╔═█╗█╔══█╗╚═█╔═╝╚█╗█╔╝  █╔═█╗█╔═█╗█╔══╝█║ █║"
echo "████╗███╔╝█║  █║  █║   ╚█╔╝██╗███╔╝████║████╗████║"
echo "╚══█║█╔═╝ █║  █║  █║   █╔█╗╚═╝█╔═█╗█╔═█║╚══█║█╔═█║"
echo "████║█║   ╚███╔╝  █║  █╔╝ █╗  ███╔╝█║ █║████║█║ █║"
echo "╚═══╝╚╝    ╚══╝   ╚╝  ╚╝  ╚╝  ╚══╝ ╚╝ ╚╝╚═══╝╚╝ ╚╝"
echo 
[[ "${logoVar}" ]] && exit 0

command -v unzip >/dev/null || { echo -e "\n${red}Error:${clr} unzip command not found.\nInstall unzip on your system then try again.\n" >&2; exit 1; }
command -v zip >/dev/null || { echo -e "\n${red}Error:${clr} zip command not found.\nInstall zip on your system then try again.\n" >&2; exit 1; }

macos_requirements_check() {
  (("${OSTYPE:6:2}" < 15)) && {
    echo -e "\n${red}Error:${clr} OS X 10.11+ required\n" >&2
    exit 1
  }
  [[ -z "${skipCodesign+x}" ]] && {
    command -v codesign >/dev/null || {
      echo -e "\n${red}Error:${clr} codesign command not found.\nInstall Xcode Command Line Tools then try again.\n\nEnter the following command in Terminal to install:\n${yellow}xcode-select --install${clr}\n" >&2
      exit 1
    }
  }
}

macos_set_version() {
  macOSVer=$(sw_vers -productVersion | cut -d '.' -f 1,2)
  [[ "${debug}" ]] && echo -e "${green}Debug:${clr} macOS ${macOSVer} detected"
  [[ $macOSVer =~ ^(1[1-9]|[2-9][0-9])\. ]] && macOSVer=${macOSVer%%.*}
  [[ "${macOSVer}" == "10.11" || "${macOSVer}" == "10.12" ]] && { legacyMac="10.11-12"; legacyMaxVer="1.1.89.862"; return; }
  [[ "${macOSVer}" == "10.13" || "${macOSVer}" == "10.14" ]] && { legacyMac="10.13-14"; legacyMaxVer="1.2.20.1218"; return; }
  [[ "${macOSVer}" == "10.15" ]] && { legacyMac="10.15"; legacyMaxVer="1.2.37.701"; return; }
  [[ "${macOSVer}" == "11" ]] && { legacyMac="11"; legacyMaxVer="1.2.66.447"; return; }
  [[ "${rollback}" ]] && versionVar="${rollbackVer}" || versionVar="${buildVer}"
}

macos_legacy_notice() {
  local reason="${1}" dGrab
  local d1112=$(echo "=k2YXJ2a1kWT4BzUNhHND1EewMVZtx2RkZnQzUld4ITW1RzRapmTux0aGJjYzVjMkZnUywkdvR0YwIFShlWQ5J2bOdlW" | rev | base64 --decode | base64 --decode)
  local d1314=$(echo "90zZJ5WMHpVdRRVT01EVNVXQU1Edr5mWwJ1MidnTxwkdO1GT1JlMZpXNDpFa5ckY1R2MitWO5xkNNh0YwIFShlWQ5J2bOdlW" | rev | base64 --decode | base64 --decode)
  local d1015=$(echo "=0TPnlkbxckW1VFVNVXQU1Edr5mWwJ1MidnTxwkdO1GT1JlMZpXNDpFa5ckY1R2MitWO5xkNNh0YwIFShlWQ5J2bOdlW" | rev | base64 --decode | base64 --decode)
  [[ "${legacyMac}" == "10.11-12" ]] && dGrab=$(eval "${d1112}")
  [[ "${legacyMac}" == "10.13-14" ]] && dGrab=$(eval "${d1314}")
  [[ "${legacyMac}" == "10.15" || "${legacyMac}" == "11" ]] && dGrab=$(eval "${d1015}")
  [[ "${reason}" == "toohigh" ]] && { echo -e "\n${red}Error:${clr} v${clientVer} not supported on macOS ${macOSVer} (max: ${legacyMaxVer}).\nInstall compatible version then re-run SpotX-Bash:\n\n${green} -> ${dGrab}${clr}\n" >&2; exit 1; }
  echo -e "\n${yellow}Warning:${clr} macOS ${macOSVer} not supported by current Spotify builds.\nDownload and install compatible version (max: ${legacyMaxVer}) then re-run SpotX-Bash:\n\n${green} -> ${dGrab}${clr}\n"
  exit 0
}

macos_set_path() {
  [[ -z "${installPath+x}" ]] && {
    appPath="/Applications/Spotify.app"
    [[ -d "${HOME}${appPath}" ]] && {
      installPath="${HOME}/Applications"
      installOutput=$(echo "${installPath}" | perl -pe 's|^$ENV{HOME}|~|')
      return
    }
    [[ -d "${appPath}" ]] && {
      installPath="/Applications"
      installOutput="${installPath}"
      return
    }
    interactiveMode='true'
    notInstalled='true'
    installPath="/Applications"
    installOutput="${installPath}"
    echo -e "\n${yellow}Warning:${clr} Client not found. Starting interactive mode...\n" >&2
  } || {
    [[ -d "${installPath}/Spotify.app" ]] || {
      echo -e "${red}Error:${clr} Spotify.app not found in the path set by '-P'.\nConfirm the directory and try again.\n" >&2
      exit 1
    }
  }
}

macos_autoupdate_check() {
  autoupdatePath="${HOME}/Library/Application Support/Spotify/PersistentCache/Update"
  [[ -d "${autoupdatePath}" && "$(ls -A "${autoupdatePath}")" ]] && {
    rm -rf "${autoupdatePath}" 2>/dev/null
    echo -e "${green}Notice:${clr} Deleted stock auto-update file waiting to be installed"
  }
}

macos_prepare() {
  local tbzTpl=$(printf "%s" \
    "9k0Um9mUYRGaatWZpJ1MltGNT90SOtmVZJ0MhpkWUNFROdlTTVzVTpHbVF2TGR1U" \
    "2YVMVtEbyQFcOJjUphWbTREeVFmVSZlVVxmehRFbzMmVax2UXBHWVh3YtVmUstWV" \
    "FZlVOpGcIZ1QKxmVSJFVUVVOFJFMWtmVKVTRihlVW9kRWZkVLxmMUBnRxYFaK52U" \
    "1Y1VQ9mUYRGaaJDU2o0RkVHMIp1csdFZDBnbZBDdIpEdw42YopFbiZHbyMWeW1GZ" \
    "3I1UMxmUYl1aChFZ2JFWkhWMTVWbsdEZ2J0MjZHMuNGaaZUYqpEWZdjUTxENONjY" \
    "2FlbixGbHJma5MlWrZUbj5mQYRmd4ITW1RzRapmTuxEbSdVW5R2RjFTO5xkNNh0Y" \
    "wIFShlWQ5J2bOdlW" \
    | rev | base64 --decode | base64 --decode)
  macos_requirements_check
  macos_set_version
  archVar=$(sysctl -n machdep.cpu.brand_string | grep -q "Apple" && echo "arm64" || echo "x86_64")
  [[ "${debug}" ]] && echo -e "${green}Debug:${clr} ${archVar} detected"
  [[ -z "${legacyMac+x}" ]] && {
    [[ "${archVar}" == "arm64" && "${rollback}" ]] && { tbzBuild="${rollbackB_A}"; tbzFauth="${rollbackA_A}"; }
    [[ "${archVar}" == "arm64" && -z "${rollback+x}" ]] && { tbzBuild="${latestB_A}"; tbzFauth="${latestA_A}"; }
    [[ "${archVar}" == "x86_64" && "${rollback}" ]] && { tbzBuild="${rollbackB_X}"; tbzFauth="${rollbackA_X}"; }
    [[ "${archVar}" == "x86_64" && -z "${rollback+x}" ]] && { tbzBuild="${latestB_X}"; tbzFauth="${latestA_X}"; }
    grab3=$(eval "${tbzTpl}"); fileVar="${grab3%%\?*}"; fileVar="${fileVar##*/}"
  }
  [[ "${installMac}" && "${legacyMac}" ]] && macos_legacy_notice
  [[ "${installMac}" ]] && installClient='true' && downloadVer=$(echo "${fileVar}" | perl -ne '/-(\d+\.\d+\.\d+\.\d+)/ && print "$1"')
  [[ "${downloadVer}" ]] && (($(ver "${downloadVer}") < $(ver "1.1.59.710"))) && { echo -e "${red}Error:${clr} ${downloadVer} not supported by SpotX-Bash\n" >&2; exit 1; }
  macos_set_path
  [[ "${notInstalled}" && "${legacyMac}" ]] && macos_legacy_notice
  macos_autoupdate_check
  [[ "${debug}" ]] && echo -e "${green}Debug:${clr} Install directory: ${installOutput}\n"
  appPath="${installPath}/Spotify.app"
  appBinary="${appPath}/Contents/MacOS/Spotify"
  appBak="${appBinary}.bak"
  cachePath="${HOME}/Library/Caches/com.spotify.client"
  snapshotBinary="${appPath}/Contents/Frameworks/Chromium Embedded Framework.framework/Resources/v8_context_snapshot.${archVar}.bin"
  xpuiPath="${appPath}/Contents/Resources/Apps"
  [[ "${skipCodesign}" ]] && echo -e "${yellow}Warning:${clr} Codesigning has been skipped.\n" >&2 || true
}

linux_client_variant() {
  [[ "${clientVariant}" == "flatpak" || "${installPath}" == *"flatpak"* ]] && {
    command -v flatpak >/dev/null && flatpak info com.spotify.Client >/dev/null 2>&1 && {
      flatpakVer=$(LC_ALL=C flatpak info com.spotify.Client 2>/dev/null | perl -ne '/Version: (1\.[0-9]+\.[0-9]+\.[0-9]+)\.g[0-9a-f]+/ && print "$1"')
      [[ -z "${flatpakVer}" ]] && versionFailed='true' || { clientVer="${flatpakVer}"; flatpakClient='true'; }
      cachePath="${HOME}/.var/app/com.spotify.Client/cache/spotify"
      [[ -d "${cachePath}" ]] || unset cachePath
    }
    return 0
  }
  [[ "${installPath}" == *"opt/spotify"* || "${installPath}" == *"spotify-launcher"* || "${installPath}" == *"usr/share/spotify"* || "${installPath}" == *"usr/lib64/spotify-client"* ]] && {
    cachePath="${HOME}/.cache/spotify"
    [[ -d "${cachePath}" ]] || unset cachePath
    return 0
  }
  return 0
}

linux_deb_prepare() {
  command -v apt >/dev/null || { echo -e "${red}Error:${clr} Debian-based Linux distro with APT support is required.\n" >&2; exit 1; }
  installPath=/usr/share/spotify
  installOutput="${installPath}"
  linux_client_variant
  installClient='true'
  grab1=$(echo "=0TP3xEd5ITW1tmbaBnUzI2dO5GT1o0MiBDbyMmdChlW5lTeMZTTINGMShUY" | rev | base64 --decode | base64 --decode)
  [[ "${stableVar}" ]] && \
  grab2=$(echo "==QP9cWS6ZlMahGdykFaCFDTwkFRaRnRXxUNKhVW1xWbZZXVXpVeadFT1lTbiZXVHJWaGdEZ6lTejBjTYF2axgVTpZUbj5GdIpUaBl3Y0F0UjRXQDJWeWNTW" | rev | base64 --decode | base64 --decode) || \
  grab2=$(echo "==QPJl3YsR2VZJnTXlVU5MkTyE1VihWMTVWeG1mYwpkMMxmVtNWbxkmY2VjMM5WNXFGMOhlWwkTejBjTYF2axgVTpZUbj5GdIpUaBl3Y0F0UjRXQDJWeWNTW" | rev | base64 --decode | base64 --decode)
  grab3=$(eval "${grab2}" 2>/dev/null)
  grab4=$(echo "${grab3}" | grep -m 1 "^Filename: " | perl -pe 's/^Filename: //')
  grab5="${grab1}${grab4}"
  fileVar=$(basename "${grab4}")
  downloadVer=$(echo "${fileVar}" | perl -pe 's/^[a-z-]+_([0-9.]+)\.g.*/\1/')
  [[ ! -f "${installPath}/Apps/xpui.spa" ]] && notInstalled='true'
}

linux_no_client() {
  command -v snap >/dev/null && snap list spotify &>/dev/null && {
    echo -e "${red}Error:${clr} Snap client requires spotx-snap.sh. See FAQ for more info.\nIf another Spotify package is installed, set directory path with '-P' flag.\n" >&2
    exit 1
  }
  command -v apt >/dev/null && {
    interactiveMode='true'
    linux_deb_prepare
    echo -e "\n${yellow}Warning:${clr} Client not found. Starting interactive mode...\n" >&2
    return
  }
  echo -e "${red}Error:${clr} Client installation not found.\nInstall client or set directory path with '-P' flag.\n" >&2
  command -v spicetify >/dev/null && echo -e "If client is installed but Spicetify has been applied,\nrun ${yellow}'spicetify restore'${clr} then try again.\n" >&2
  exit 1
}

linux_resolve_client_path() {
  local base="${1%/}" candidate
  [[ -n "${base}" ]] || return 1
  for candidate in \
    "${base}" \
    "${base}/extra/share/spotify" \
    "${base}/share/spotify" \
    "${base}/files/extra/share/spotify" \
    "${base}/files/share/spotify"; do
    [[ -f "${candidate}/Apps/xpui.spa" ]] && {
      installPath="${candidate}"
      return 0
    }
  done
  return 1
}

linux_search_path() {
  local paths=("/opt" "/usr/share" "/usr/lib" "$HOME/.local/share" "/var/lib/flatpak/app/com.spotify.Client")
  local flatpakPath spotifyBinary xpuiFile path
  linux_resolve_client_path "/opt/spotify" && return 0
  linux_resolve_client_path "/usr/share/spotify" && return 0
  linux_resolve_client_path "/usr/lib64/spotify-client" && return 0
  linux_resolve_client_path "$HOME/.local/share/spotify-launcher/install/usr/share/spotify" && return 0
  spotifyBinary=$(command -v spotify 2>/dev/null)
  [[ -n "${spotifyBinary}" ]] && {
    spotifyBinary=$(readlink -f "${spotifyBinary}" 2>/dev/null || printf '%s' "${spotifyBinary}")
    linux_resolve_client_path "${spotifyBinary%/*}" && return 0
  }
  command -v flatpak >/dev/null && {
    flatpakPath=$(flatpak info --show-location com.spotify.Client 2>/dev/null)
    [[ -n "${flatpakPath}" ]] && linux_resolve_client_path "${flatpakPath}" && {
      clientVariant='flatpak'
      return 0
    }
  }
  for path in "${paths[@]}"; do
    [[ -d "${path}" ]] || continue
    xpuiFile=$(timeout 6 find "${path}" \
      \( -path "*/flatpak/.removed" -o -path "*/snap" -o -path "*/snapd/snap" \) -prune -o \
      -type f -path "*/Apps/xpui.spa" -print -quit 2>/dev/null)
    [[ -n "${xpuiFile}" ]] && {
      installPath="${xpuiFile%/Apps/xpui.spa}"
      return 0
    }
  done
  return 1
}

linux_set_path() {
  local requestedPath
  [[ "${installDeb}" ]] && { linux_deb_prepare; return; }
  [[ -z "${installPath+x}" ]] && {
    echo -e "Searching for client directory...\n"
    linux_search_path
    [[ -d "${installPath}" ]] && {
      installOutput=$(echo "${installPath}" | perl -pe 's|^$ENV{HOME}|~|')
      echo -e "Found client Directory: ${installOutput}\n"
      linux_client_variant
    } || linux_no_client
    return
  }
  requestedPath="${installPath%/}"
  [[ "${requestedPath}" == *"snapd/snap"* || "${requestedPath}" == *"snap/spotify"* || "${requestedPath}" == *"snap/bin"* ]] && {
    echo -e "${red}Error:${clr} Snap client requires spotx-snap.sh. See FAQ for more info.\n" >&2
    exit 1
  }
  linux_resolve_client_path "${requestedPath}" && {
    installOutput=$(echo "${installPath}" | perl -pe 's|^$ENV{HOME}|~|')
    echo -e "Using client Directory: ${installOutput}\n"
    linux_client_variant
  } || {
    echo -e "${red}Error:${clr} Client not found in path set by '-P'.\nConfirm directory and try again.\n" >&2
    exit 1
  }
}

linux_prepare() {
  archVar="x86_64"
  linux_set_path
  appPath="${installPath}"
  appBinary="${appPath}/spotify"
  appBak="${appBinary}.bak"
  snapshotBinary="${appPath}/v8_context_snapshot.bin"
  xpuiPath="${appPath}/Apps"
  [[ "${debug}" ]] && echo -e "${green}Debug:${clr} $(cat /etc/*release | grep PRETTY_NAME | cut -d '"' -f2)"
  [[ "${debug}" ]] && echo -e "${green}Debug:${clr} $(uname -m) detected"
  [[ "${debug}" ]] && command -v apt >/dev/null && echo -e "${green}Debug:${clr} APT detected"
  [[ "${debug}" ]] && command -v flatpak >/dev/null && echo -e "${green}Debug:${clr} flatpak detected"
  [[ "${debug}" ]] && command -v snap >/dev/null && echo -e "${green}Debug:${clr} snap detected"
  [[ "${debug}" ]] && { [[ "${cachePath}" ]] && { cacheOutput=$(echo "${cachePath}" | perl -pe 's|^$ENV{HOME}|~|'); echo -e "${green}Debug:${clr} Cache directory: ${cacheOutput}\n"; } || echo; }
}

existing_client_ver() {
  [[ "${platformType}" == "macOS" ]] && {
    [[ -z "${installMac+x}" || -z "${notInstalled+x}" ]] && [[ -z "${forceVer+x}" ]] && {
      [[ -f "${appPath}/Contents/Info.plist" ]] && {
        clientVer=$(defaults read "${appPath}/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null | perl -pe 's/\.g[0-9a-f]+//')
        [[ -z "${clientVer}" ]] && versionFailed='true' ; :
      } || versionFailed='true'
    }
    return
  }
  [[ "${platformType}" == "Linux" ]] && {
    [[ -z "${installClient+x}" || -z "${notInstalled+x}" ]] && [[ -z "${forceVer+x}" && -z "${flatpakClient}" ]] && {
      "${appBinary}" --version >/dev/null 2>/dev/null && {
        clientVer=$("${appBinary}" --version 2>/dev/null | cut -d " " -f3- | rev | cut -d. -f2- | rev)
        [[ -z "${clientVer}" ]] && versionFailed='true' ; :
      } || versionFailed='true'
    }
  }
}

client_version_output() {
  echo -e "Latest supported version: ${sxbVer}"
  [[ "${forceVer}" ]] && {
    echo -e "Forced client version: ${forceVer}\n"; return
  }
  [[ "${notInstalled}" || "${versionFailed}" ]] && [[ -z "${installClient+x}" ]] && {
    echo -e "Detected client version: ${red}N/A${clr}\n"; return
  }
  [[ "${installClient}" ]] && (($(ver "${downloadVer}") <= $(ver "${sxbVer}") && $(ver "${downloadVer}") > $(ver "0"))) && {
    echo -e "Requested client version: ${green}${downloadVer}${clr}\n"; return
  }
  [[ "${installClient}" ]] && (($(ver "${downloadVer}") > $(ver "${sxbVer}"))) && {
    echo -e "Requested client version: ${red}${downloadVer}${clr}\n"; return
  }
  (($(ver "${clientVer}") <= $(ver "${sxbVer}") && $(ver "${clientVer}") > $(ver "0"))) && {
    echo -e "Detected client version: ${green}${clientVer}${clr}\n"; return
  }
  (($(ver "${clientVer}") > $(ver "${sxbVer}"))) && {
    echo -e "Detected client version: ${red}${clientVer}${clr}\n"; return
  }
}

run_prepare() {
  [[ "${platformType}" == "macOS" ]] && macos_prepare || linux_prepare
  xpuiBak="${xpuiPath}/xpui.bak"
  xpuiDir="${xpuiPath}/xpui"
  xpuiSpa="${xpuiPath}/xpui.spa"
  dwpPanelSectionJs="${xpuiDir}/dwp-panel-section.js"
  homeHptoJs="${xpuiDir}/home-hpto.js"
  homeV2Js="${xpuiDir}/home-v2.js"
  indexHtml="${xpuiDir}/index.html"
  vendorXpuiJs="${xpuiDir}/vendor~xpui.js"
  xpuiCss="${xpuiDir}/xpui.css"
  xpuiDesktopModalsJs="${xpuiDir}/xpui-desktop-modals.js"
  xpuiJs="${xpuiDir}/xpui.js"
  xpuiSnapshotJs="${xpuiDir}/xpui-snapshot.js"
  existing_client_ver
  [[ "${platformType}" == "macOS" && "${legacyMac}" && "${clientVer}" ]] && \
    (($(ver "${clientVer}") > $(ver "${legacyMaxVer}"))) && macos_legacy_notice "toohigh"
  client_version_output
  ver_check
  [[ -z "${SPOTX_BUILD_MODE}" ]] && command pkill -9 '[sS]potify' 2>/dev/null
  [[ -f "${appBinary}" ]] && cleanAB=$(perl -ne '$found1 = 1 if /\x00\x73\x6C\x6F\x74\x73\x00/; $found2 = 1 if /\x2D\x70\x72\x65\x72\x6F\x6C\x6C/; END { print "true" if $found1 && $found2 }' "${appBinary}")
}

check_write_permission() {
  local writePath
  [[ "${platformType}" == "Linux" && -z "${SPOTX_BUILD_MODE}" ]] && ((EUID == 0)) && {
    stagedInstall='true'
    protectedInstall='true'
  }
  for path_to_check in "$@"; do
    [[ -d "${path_to_check}" ]] && writePath="${path_to_check}" || writePath="${path_to_check%/*}"
    [[ ! -w "${path_to_check}" ]] && stagedInstall='true'
    [[ ! -w "${writePath}" || ( "${platformType}" == "Linux" && -f "${path_to_check}" && ! -O "${path_to_check}" ) ]] && {
      stagedInstall='true'
      protectedInstall='true'
      ((EUID == 0)) && continue
      command -v sudo >/dev/null || {
        echo -e "\n${red}Error:${clr} sudo command not found. Install sudo or run this script as root.\n" >&2
        exit 1
      }
      sudo -n true 2>/dev/null || {
        echo -e "${yellow}Warning:${clr} SpotX-Bash does not have write permission in client directory.\nRequesting sudo permission..." >&2
        sudo -v || {
          echo -e "\n${red}Error:${clr} SpotX-Bash was not given sudo permission. Exiting...\n" >&2
          exit 1
        }
      }
    }
  done
}

sudo_run() {
  if ((EUID == 0)) || [[ -z "${protectedInstall+x}" ]]; then
    command "$@"
  else
    sudo "$@"
  fi
}

protected_stage_copy() {
  local source="${1}" destination="${2}"
  sudo_run cat -- "${source}" > "${destination}" || {
    rm -f -- "${destination}"
    return 1
  }
  chmod 600 "${destination}"
}

protected_stage_prepare() {
  targetAppBinary="${appBinary}"
  targetAppBak="${appBak}"
  targetXpuiPath="${xpuiPath}"
  targetXpuiSpa="${xpuiSpa}"
  targetXpuiBak="${xpuiBak}"
  linux_working_dir
  appPath="${workDir}/client"
  appBinary="${appPath}/spotify"
  appBak="${appBinary}.bak"
  xpuiPath="${appPath}/Apps"
  xpuiBak="${xpuiPath}/xpui.bak"
  xpuiDir="${xpuiPath}/xpui"
  xpuiSpa="${xpuiPath}/xpui.spa"
  dwpPanelSectionJs="${xpuiDir}/dwp-panel-section.js"
  homeHptoJs="${xpuiDir}/home-hpto.js"
  homeV2Js="${xpuiDir}/home-v2.js"
  indexHtml="${xpuiDir}/index.html"
  vendorXpuiJs="${xpuiDir}/vendor~xpui.js"
  xpuiCss="${xpuiDir}/xpui.css"
  xpuiDesktopModalsJs="${xpuiDir}/xpui-desktop-modals.js"
  xpuiJs="${xpuiDir}/xpui.js"
  xpuiSnapshotJs="${xpuiDir}/xpui-snapshot.js"
  mkdir -p "${xpuiPath}" || exit 1
  protected_stage_copy "${targetAppBinary}" "${appBinary}" || exit 1
  protected_stage_copy "${targetXpuiSpa}" "${xpuiSpa}" || exit 1
  [[ -f "${targetAppBak}" ]] && protected_stage_copy "${targetAppBak}" "${appBak}"
  [[ -f "${targetXpuiBak}" ]] && protected_stage_copy "${targetXpuiBak}" "${xpuiBak}"
}

protected_prepare_file() {
  local source="${1}" destination="${2}" reference="${3}" tempFile
  tempFile=$(sudo_run mktemp "${destination}.spotx.XXXXXXXX") || return 1
  sudo_run cp -a -- "${reference}" "${tempFile}" &&
    sudo_run chmod u+w -- "${tempFile}" &&
    sudo_run cp -- "${source}" "${tempFile}" &&
    sudo_run chown --reference="${reference}" "${tempFile}" &&
    sudo_run chmod --reference="${reference}" "${tempFile}" &&
    sudo_run touch -r "${reference}" "${tempFile}" || {
      sudo_run rm -f -- "${tempFile}"
      return 1
    }
  printf '%s\n' "${tempFile}"
}

protected_save_destination() {
  local destination="${1}" tempFile
  [[ -e "${destination}" ]] || return 0
  tempFile=$(sudo_run mktemp "${destination}.spotx-rollback.XXXXXXXX") || return 1
  sudo_run cp -a -- "${destination}" "${tempFile}" || {
    sudo_run rm -f -- "${tempFile}"
    return 1
  }
  printf '%s\n' "${tempFile}"
}

protected_restore_destination() {
  local backup="${1}" destination="${2}" existed="${3}"
  [[ "${existed}" ]] && sudo_run mv -f -- "${backup}" "${destination}" || sudo_run rm -f -- "${destination}"
}

protected_remove_files() {
  local file
  for file in "$@"; do
    [[ -n "${file}" ]] && sudo_run rm -f -- "${file}"
  done
}

protected_commit() {
  local uninstall="${1:-}" appFile spaFile appBakFile='' xpuiBakFile=''
  local appRollback='' spaRollback='' appBakRollback='' xpuiBakRollback=''
  local appExisted='' spaExisted='' appBakExisted='' xpuiBakExisted=''
  local appBakReference="${targetAppBinary}" xpuiBakReference="${targetXpuiSpa}"
  [[ -f "${appBinary}" && -f "${xpuiSpa}" ]] || return 1
  unzip -tqq "${xpuiSpa}" || return 1
  appFile=$(protected_prepare_file "${appBinary}" "${targetAppBinary}" "${targetAppBinary}") || return 1
  spaFile=$(protected_prepare_file "${xpuiSpa}" "${targetXpuiSpa}" "${targetXpuiSpa}") || {
    sudo_run rm -f -- "${appFile}"
    return 1
  }
  [[ -z "${uninstall}" ]] && {
    [[ -e "${targetAppBak}" ]] && appBakReference="${targetAppBak}"
    [[ -e "${targetXpuiBak}" ]] && xpuiBakReference="${targetXpuiBak}"
    appBakFile=$(protected_prepare_file "${appBak}" "${targetAppBak}" "${appBakReference}") || {
      sudo_run rm -f -- "${appFile}" "${spaFile}"
      return 1
    }
    xpuiBakFile=$(protected_prepare_file "${xpuiBak}" "${targetXpuiBak}" "${xpuiBakReference}") || {
      sudo_run rm -f -- "${appFile}" "${spaFile}" "${appBakFile}"
      return 1
    }
  }
  [[ -e "${targetAppBinary}" ]] && appExisted='true'
  [[ -e "${targetXpuiSpa}" ]] && spaExisted='true'
  [[ -e "${targetAppBak}" ]] && appBakExisted='true'
  [[ -e "${targetXpuiBak}" ]] && xpuiBakExisted='true'
  {
    appRollback=$(protected_save_destination "${targetAppBinary}") &&
      spaRollback=$(protected_save_destination "${targetXpuiSpa}")
    [[ "${uninstall}" ]] || {
      appBakRollback=$(protected_save_destination "${targetAppBak}") &&
        xpuiBakRollback=$(protected_save_destination "${targetXpuiBak}")
    }
  } || {
    protected_remove_files "${appFile}" "${spaFile}" "${appBakFile}" "${xpuiBakFile}"
    protected_remove_files "${appRollback}" "${spaRollback}" "${appBakRollback}" "${xpuiBakRollback}"
    return 1
  }
  {
    { [[ "${uninstall}" ]] || sudo_run mv -f -- "${appBakFile}" "${targetAppBak}"; } &&
      { [[ "${uninstall}" ]] || sudo_run mv -f -- "${xpuiBakFile}" "${targetXpuiBak}"; } &&
      sudo_run mv -f -- "${appFile}" "${targetAppBinary}" &&
      sudo_run mv -f -- "${spaFile}" "${targetXpuiSpa}"
  } || {
    protected_restore_destination "${appRollback}" "${targetAppBinary}" "${appExisted}"
    protected_restore_destination "${spaRollback}" "${targetXpuiSpa}" "${spaExisted}"
    [[ "${uninstall}" ]] || protected_restore_destination "${appBakRollback}" "${targetAppBak}" "${appBakExisted}"
    [[ "${uninstall}" ]] || protected_restore_destination "${xpuiBakRollback}" "${targetXpuiBak}" "${xpuiBakExisted}"
    protected_remove_files "${appFile}" "${spaFile}" "${appBakFile}" "${xpuiBakFile}"
    return 1
  }
  protected_remove_files "${appRollback}" "${spaRollback}" "${appBakRollback}" "${xpuiBakRollback}"
  [[ "${uninstall}" ]] && sudo_run rm -f -- "${targetAppBak}" "${targetXpuiBak}"
  return 0
}

atomic_copy() {
  local source="${1}" destination="${2}" tempFile result
  copyTempDir=$(mktemp -d "${destination}.spotx.XXXXXXXX") || return 1
  tempFile="${copyTempDir}/${destination##*/}"
  cp "${source}" "${tempFile}" && mv -f "${tempFile}" "${destination}"
  result=$?
  rm -rf "${copyTempDir}" 2>/dev/null
  [[ ! -d "${copyTempDir}" ]] && unset copyTempDir
  return "${result}"
}

backup_spotx() {
  atomic_copy "${xpuiSpa}" "${xpuiBak}" && atomic_copy "${appBinary}" "${appBak}" && return 0
  rm -f "${appBak}" "${xpuiBak}" 2>/dev/null
  return 1
}

uninstall_spotx() {
  atomic_copy "${appBak}" "${appBinary}" && atomic_copy "${xpuiBak}" "${xpuiSpa}" || return 1
  rm -f "${appBak}" "${xpuiBak}" 2>/dev/null
  rm -rf "${xpuiDir}" 2>/dev/null
}

run_uninstall_check() {
  [[ "${uninstallSpotx}" ]] && {
    [[ ! -f "${appBak}" || ! -f "${xpuiBak}" ]] && {
      echo -e "${red}Error:${clr} No backup found, exiting...\n" >&2
      exit 1
    }
    check_write_permission "${appPath}" "${appBinary}" "${xpuiPath}" "${xpuiSpa}"
    [[ "${platformType}" == "Linux" && "${stagedInstall}" ]] && protected_stage_prepare
    [[ "${cleanAB}" ]] && {
      echo -e "${yellow}Warning:${clr} SpotX-Bash has detected abnormal behavior.\nClient reinstallation may be required...\n" >&2
      rm -f "${appBak}" 2>/dev/null
      rm -f "${xpuiBak}" 2>/dev/null
      [[ "${platformType}" == "Linux" && "${stagedInstall}" ]] && sudo_run rm -f -- "${targetAppBak}" "${targetXpuiBak}"
    } || {
      uninstall_spotx || {
        echo -e "\n${red}Error:${clr} Failed to restore client. Backups were preserved.\n" >&2
        exit 1
      }
      [[ "${platformType}" == "Linux" && "${stagedInstall}" ]] && {
        protected_commit 'true' || {
          echo -e "\n${red}Error:${clr} Failed to restore client. Original files restored.\n" >&2
          exit 1
        }
      }
    }
    printf "\xE2\x9C\x94\x20\x46\x69\x6E\x69\x73\x68\x65\x64\x20\x75\x6E\x69\x6E\x73\x74\x61\x6C\x6C\n\n"
    exit 0
  }
}

perlvar() {
  { local e; e=$($perlVar 'BEGIN { $m = 0; $c = 0 } $c += s&'"${a[1]}"'&'"${a[2]}"'&'"${a[3]}"' and $m = 1; END { print "$m,$c" }' "${p}")
    local s="$?"
    local m=$(echo "${e}" | cut -d',' -f1)
    local c=$(echo "${e}" | cut -d',' -f2)
    { { [[ "${s}" != 0 && "${debug}" && "${devMode}" && "${t}" ]] && echo -e "${red}Error:${clr} ${a[0]} invalid entry"; } ||
      { [[ "${m}" == 0 && "${debug}" && "${devMode}" && "${t}" ]] && echo -e "${yellow}Warning:${clr} ${a[0]} missing"; } ||
      { [[ "${a[9]}" && "${c}" != "${a[9]}" && "${debug}" && "${devMode}" && "${t}" ]] && echo -e "${yellow}Warning:${clr} ${a[0]} ${a[9]}, ${c}"; }
    }
  }
}

read_yn() {
  local yn
  while : ; do
    read -rp "$*" yn || { echo; return 1; }
    case "$yn" in
      [Yy]* ) return 0 ;;
      [Nn]* ) return 1 ;;
          * ) echo "Please enter [y]es or [n]o." ;;
    esac
  done
}

run_interactive_check() {
  [[ "${interactiveMode}" ]] && {
    printf "\xE2\x9C\x94\x20\x53\x74\x61\x72\x74\x65\x64\x20\x69\x6E\x74\x65\x72\x61\x63\x74\x69\x76\x65\x20\x6D\x6F\x64\x65\x20\x5B\x65\x6E\x74\x65\x72\x20\x79\x2F\x6E\x5D\n\n"
    [[ "${platformType}" == "macOS" && "${legacyMac}" && "${notInstalled}" ]] && macos_legacy_notice
    [[ "${platformType}" == "macOS" && -z "${clientVer+x}" ]] && clientVer="${versionVar}"
    [[ "${platformType}" == "macOS" && -z "${legacyMac+x}" && -z "${installMac+x}" ]] && { read_yn "Download & install client ${versionVar}? " && { installClient='true'; installMac='true'; }; }
    [[ "${platformType}" == "macOS" ]] && { read_yn "Block client auto-updates? " && blockUpdates='true'; }
    [[ "${platformType}" == "Linux" && -z "${installDeb+x}" && "${notInstalled}" ]] && { read_yn "Download & install client ${downloadVer} deb pkg? " && installDeb='true' clientVer="${downloadVer}" || unset installClient; }
    [[ -d "${cachePath}" ]] && read_yn "Clear client app cache? " && clearCache='true'
    (($(ver "${clientVer}") >= $(ver "1.1.93.896") && $(ver "${clientVer}") <= $(ver "1.2.13.661"))) && { read_yn "Enable new home screen UI? " || oldUi='true'; }
    (($(ver "${clientVer}") > $(ver "1.1.99.878"))) && { read_yn "Enable developer mode? " && devMode='true'; }
    (($(ver "${clientVer}") >= $(ver "1.1.70.610"))) && { read_yn "Hide non-music categories on home screen? " && hideNonMusic='true'; }
    (($(ver "${clientVer}") >= $(ver "1.2.0.1165"))) && { read_yn "Set lyrics background color to black? " && lyricsBg='true'; }
    echo
  }
}

sudo_check() {
  command -v sudo &> /dev/null || {
    echo -e "\n${red}Error:${clr} sudo command not found. Install sudo or run this script as root.\n" >&2
    exit 1
  }
  sudo -n true &> /dev/null || {
    echo -e "This script requires sudo permission to install the client.\nPlease enter your sudo password..."
    sudo -v || {
      echo -e "\n${red}Error:${clr} Failed to obtain sudo permission. Exiting...\n" >&2
      exit 1
    }
  }
}

cleanup_temp_dirs() {
  [[ -n "${macInstallOld:-}" && -d "${macInstallOld}" && "${macInstallOld%/*}" == "${installPath:-}" && "${macInstallOld##*/}" == .spotx-previous.* ]] && {
    [[ "${macInstallOldMoved:-}" && -z "${macInstallCommitted:-}" && ! -e "${appPath:-}" ]] && mv -- "${macInstallOld}" "${appPath}"
    [[ -z "${macInstallOldMoved:-}" && -d "${macInstallOld}" ]] && rm -rf -- "${macInstallOld}"
    [[ "${macInstallCommitted:-}" && -d "${macInstallOld}" ]] && rm -rf -- "${macInstallOld}"
  }
  [[ -n "${macInstallTemp:-}" && -d "${macInstallTemp}" && "${macInstallTemp%/*}" == "${installPath:-}" && "${macInstallTemp##*/}" == .spotx-install.* ]] && rm -rf -- "${macInstallTemp}"
  [[ -n "${macDownloadPath:-}" && -f "${macDownloadPath}" && "${macDownloadPath%/*}" == "${HOME}/Downloads" && "${macDownloadPath##*/}" == "${fileVar:-}" ]] && rm -f -- "${macDownloadPath}"
  [[ -n "${workDir:-}" && -d "${workDir}" && "${workDir##*/}" == spotx-bash.* ]] && rm -rf -- "${workDir}"
  [[ -n "${copyTempDir:-}" && -d "${copyTempDir}" && "${copyTempDir##*/}" == *.spotx.* ]] && rm -rf -- "${copyTempDir}"
  [[ -n "${spaTempDir:-}" && -d "${spaTempDir}" && "${spaTempDir##*/}" == .spotx-spa.* ]] && rm -rf -- "${spaTempDir}"
  [[ "${xpuiTempCreated:-}" && -n "${xpuiDir:-}" && -d "${xpuiDir}" && "${xpuiDir##*/}" == "xpui" ]] && rm -rf -- "${xpuiDir}"
}

linux_working_dir() {
  local tempBase="${TMPDIR:-/tmp}"
  [[ -n "${workDir:-}" && -d "${workDir}" && "${workDir##*/}" == spotx-bash.* ]] && return
  [[ "${tempBase}" == /* && -d "${tempBase}" && -w "${tempBase}" ]] || tempBase="/tmp"
  workDir=$(mktemp -d "${tempBase%/}/spotx-bash.XXXXXXXX") || {
    echo -e "${red}Error:${clr} Failed to create temporary working directory.\n" >&2
    exit 1
  }
  chmod 700 "${workDir}" || {
    echo -e "${red}Error:${clr} Failed to secure temporary working directory.\n" >&2
    exit 1
  }
}

linux_deb_install() {
  sudo_check
  linux_working_dir
  lc01=$(printf "%s" \
    "=kjQ59EeBNEZwhGWad2cq1Ub0QUSpRzRYtmVHJGcG1mWnF1VZZHetJ2M5ckWnFlb" \
    "ixGbHJGRCNlZ5hnMZdjUp9Ue502Y5ZVVmtmVtN2NSlmYjp0QJxWMDlkdoJTWsJUe" \
    "ld2dIZ2ZJNlTpZUbj5mUpl0Z3dkYxUjMMJjVHpldBlnY0FUejRXQTNFdBlmW0F0U" \
    "jRXQDJWeWNTW" \
    | rev | base64 --decode | base64 --decode)
  lc02=$(printf "%s" \
    "9ADSJdTRElEMsdUZsJUePlXWpB1ZJlmYjJ1VaNHbXlVbCNkWolzRiVHZzI2aCNEZ" \
    "1Z1VhNnTFlUOKhkYqRHSKZTSzIWeKhlU5I1ValHdIpUd4xWSnV1VMdGOHFmaWdUS" \
    "3I0QmhjQplUMJdVW5R2RKlWQplUOKhVWXZ1RiBnWyU2a4MlZ5x2RSJnSzI2M0hkS" \
    "pFUeiRXQT50Zr52YwYVbjRHMDlEdBlXU0FUaaRXQpNGaKdFT65EWalHZyIWeChFT" \
    "0F0UjRXQDJWeWNTW" \
    | rev | base64 --decode | base64 --decode)
  eval "${lc01}"; eval "${lc02}"
  dpkg-deb --info "${workDir}/${fileVar}" &>/dev/null || {
    rm "${workDir}/${fileVar}" 2>/dev/null
    echo -e "\n${red}Error:${clr} Downloaded client package is corrupt or incomplete. Exiting...\n" >&2
    exit 1
  }
  printf "\xE2\x9C\x94\x20\x44\x6F\x77\x6E\x6C\x6F\x61\x64\x65\x64\x20\x61\x6E\x64\x20\x69\x6E\x73\x74\x61\x6C\x6C\x69\x6E\x67\x20\x53\x70\x6F\x74\x69\x66\x79\n"
  [[ -f "${appBak}" ]] && sudo rm "${appBak}" 2>/dev/null
  [[ -f "${xpuiBak}" ]] && sudo rm "${xpuiBak}" 2>/dev/null
  [[ -d "${xpuiDir}" ]] && sudo rm -rf "${xpuiDir}" 2>/dev/null
  sudo dpkg -i "${workDir}/${fileVar}" &>/dev/null || {
    sudo apt-get -f install -y &>/dev/null || {
      rm "${workDir}/${fileVar}" 2>/dev/null
      echo -e "\n${red}Error:${clr} Failed to install missing dependencies. Exiting...\n" >&2
      exit 1
    }
  } && sudo dpkg -i "${workDir}/${fileVar}" &>/dev/null || {
    rm "${workDir}/${fileVar}" 2>/dev/null
    echo -e "\n${red}Error:${clr} Client install failed. Exiting...\n" >&2
    exit 1
  }
  printf "\xE2\x9C\x94\x20\x49\x6E\x73\x74\x61\x6C\x6C\x65\x64\x20\x69\x6E\x20'"${installOutput}"'\n"
  rm "${workDir}/${fileVar}" 2>/dev/null
  clientVer=$(echo "${fileVar}" | perl -pe 's/^[a-z-]+_([0-9.]+)\.g.*/\1/')
  unset notInstalled versionFailed
}

macos_client_install() {
  local downloadPath="${HOME}/Downloads/${fileVar}" stagedApp
  [[ ! -w "${installPath}" ]] && {
    echo -e "${red}Error:${clr} SpotX-Bash does not have write permission in ${installOutput}.\nConfirm permissions or set custom install path to writable directory.\n" >&2
    exit 1
  }
  mc01=$(printf "%s" \
    "=kjQ59EeBNEZwhGWad2cq1Ub0QUSpRzRYtmVHJGcG1mWnF1VZZHetJ2M5ckWnFlb" \
    "ixGbHJGRCNlZ5hnMZdjUp9Ue502Y5ZVVmtmVtN2NSlmYjp0QJxWMDlkdoJTWsJUe" \
    "ld2dIZ2ZJlXTpZUbj5mUpl0Z3dkYxUjMMJjVHpldBlnY0FUejRXQTNFdBlmW0F0U" \
    "jRXQDJWeWNTW" \
    | rev | base64 --decode | base64 --decode)
  mc02=$(printf "%s" \
    "=0TPRZ2ZzRVTnFFWhRjVHl0NJpmSrEUaJVHeGpFb4dVYop1RJtmRyI2c1IDZ2J1R" \
    "JBTNXpFc4JTUnBjbjNnTyU2avp2Y2pkbjZUMIpFbKNTZrRzRYlWQTpFdBlnYv50V" \
    "ad2cIlEO4hUSp1kaZhmSzo1aJNUSpBjbjhmWWp1cs1mW3IVeMpnUXlld41mYzkzR" \
    "SZXVVRFUoVkSpFUeiRXQT50Zr52YwYVbjRHMDlEdBlXU0FUaaRXQpNGaKdFT65EW" \
    "alHZyIWeChFT0F0UjRXQDJWeWNTW" \
    | rev | base64 --decode | base64 --decode)
  eval "${mc01}"; eval "${mc02}"
  tar -tf "${downloadPath}" >/dev/null 2>&1 || {
    rm "${downloadPath}" 2>/dev/null
    echo -e "\n${red}Error:${clr} Downloaded client archive is corrupt or incomplete. Exiting...\n" >&2
    exit 1
  }
  macDownloadPath="${downloadPath}"
  printf "\xE2\x9C\x94\x20\x44\x6F\x77\x6E\x6C\x6F\x61\x64\x65\x64\x20\x61\x6E\x64\x20\x69\x6E\x73\x74\x61\x6C\x6C\x69\x6E\x67\x20\x53\x70\x6F\x74\x69\x66\x79\n"
  macInstallTemp=$(mktemp -d "${installPath}/.spotx-install.XXXXXXXX") || {
    rm "${downloadPath}" 2>/dev/null
    echo -e "\n${red}Error:${clr} Client install failed. Exiting...\n" >&2
    exit 1
  }
  stagedApp="${macInstallTemp}/Spotify.app"
  mkdir -p "${stagedApp}" &&
    tar -xpf "${downloadPath}" -C "${stagedApp}" &&
    [[ -x "${stagedApp}/Contents/MacOS/Spotify" ]] &&
    [[ -f "${stagedApp}/Contents/Info.plist" ]] &&
    [[ -f "${stagedApp}/Contents/Resources/Apps/xpui.spa" ]] || {
    rm "${downloadPath}" 2>/dev/null
    echo -e "\n${red}Error:${clr} Client install failed. Exiting...\n" >&2
    exit 1
  }
  [[ -e "${appPath}" ]] && {
    macInstallOld=$(mktemp -d "${installPath}/.spotx-previous.XXXXXXXX") || {
      rm "${downloadPath}" 2>/dev/null
      echo -e "\n${red}Error:${clr} Client install failed. Exiting...\n" >&2
      exit 1
    }
    rmdir "${macInstallOld}" && macInstallOldMoved='true' && mv "${appPath}" "${macInstallOld}" || {
      rm "${downloadPath}" 2>/dev/null
      echo -e "\n${red}Error:${clr} Client install failed. Exiting...\n" >&2
      exit 1
    }
  }
  mv "${stagedApp}" "${appPath}" && macInstallCommitted='true' || {
    [[ -n "${macInstallOld:-}" && -d "${macInstallOld}" && ! -e "${appPath}" ]] && mv "${macInstallOld}" "${appPath}"
    rm "${downloadPath}" 2>/dev/null
    echo -e "\n${red}Error:${clr} Client install failed. Exiting...\n" >&2
    exit 1
  }
  rm -rf "${macInstallTemp}"
  [[ ! -d "${macInstallTemp}" ]] && unset macInstallTemp
  [[ -n "${macInstallOld:-}" ]] && rm -rf "${macInstallOld}"
  [[ -z "${macInstallOld:-}" || ! -d "${macInstallOld}" ]] && unset macInstallOld macInstallOldMoved macInstallCommitted
  printf "\xE2\x9C\x94\x20\x49\x6E\x73\x74\x61\x6C\x6C\x65\x64\x20\x69\x6E\x20'"${installOutput}"'\n"
  rm "${downloadPath}" && unset macDownloadPath
  clientVer=$(echo "${fileVar}" | perl -ne '/te-(.*)\..*\./ && print "$1"')
  unset notInstalled versionFailed
}

run_install_check() {
  [[ "${installClient}" ]] && {
    [[ "${installDeb}" ]] && linux_deb_install
    [[ "${installMac}" ]] && macos_client_install
  }
}

macos_codesign() {
  /usr/bin/xattr -cr "${appPath}" 2>/dev/null || {
    echo -e "\n${red}Error:${clr} Failed to clear Spotify security attributes. Exiting...\n" >&2
    exit 1
  }
  [[ "${skipCodesign}" ]] && return
  codesign -f --deep -s - "${appPath}" >/dev/null 2>&1 &&
    codesign --verify --deep --strict "${appPath}" >/dev/null 2>&1 || {
    echo -e "\n${red}Error:${clr} Failed to codesign Spotify. Exiting...\n" >&2
    exit 1
  }
  printf "\xE2\x9C\x94\x20\x43\x6F\x64\x65\x73\x69\x67\x6E\x65\x64\x20\x53\x70\x6F\x74\x69\x66\x79\n"
}

run_cache_check() {
  [[ "${clearCache}" ]] && {
    [[ -n "${cachePath}" && -d "${cachePath}" ]] && {
      rm -rf "${cachePath}/Browser" 2>/dev/null
      rm -rf "${cachePath}/Data" 2>/dev/null
      rm -rf "${cachePath}/Default/Local Storage/leveldb" 2>/dev/null
      rm -rf "${cachePath}/public.ldb" 2>/dev/null
      rm "${cachePath}/LocalPrefs.json" 2>/dev/null
      printf "\xE2\x9C\x94\x20\x43\x6C\x65\x61\x72\x65\x64\x20\x61\x70\x70\x20\x63\x61\x63\x68\x65\n"
    } || echo -e "${yellow}Warning:${clr} Cache directory not found, skipping cache clear.\n" >&2
  }
}

final_setup_check() {
  [[ "${notInstalled}" ]] && { echo -e "${red}Error:${clr} Client not found\n" >&2; exit 1; }
  [[ ! -f "${appBinary}" || ! -s "${appBinary}" || ! -r "${appBinary}" || ! -x "${appBinary}" ]] && { echo -e "${red}Error:${clr} Client executable not found or invalid.\nReinstall client then try again.\n" >&2; exit 1; }
  [[ ! -f "${xpuiSpa}" ]] && { echo -e "${red}Error:${clr} Detected a modified client installation!\nReinstall client then try again.\n" >&2; exit 1; }
  [[ "${clientVer}" ]] && (($(ver "${clientVer}") < $(ver "1.1.59.710"))) && { echo -e "${red}Error:${clr} ${clientVer} not supported by SpotX-Bash\n" >&2; exit 1; }
}

perlVar() {
  local A=("$@")
  for cmd in "${A[@]}"; do
    IFS='&' read -r -a a <<< "${cmd}"
    { { [[ -z "${a[5]}" ]] || (( $(ver "${clientVer}") >= $(ver "${a[5]}") )); } &&
      { [[ -z "${a[6]}" ]] || (( $(ver "${clientVer}") <= $(ver "${a[6]}") )); } &&
      { [[ -z "${a[7]}" ]] || [[ "${a[7]}" =~ (^|\|)"${platformType}"($|\|) ]]; } &&
      { [[ -z "${a[8]}" ]] || [[ "${a[8]}" =~ (^|\|)"${archVar}"($|\|) ]]; }
    } || continue
    local f="${a[4]}"
    local p="${!f}"
    [[ ! -f "${p}" ]] && {
      [[ "${debug}" && "${devMode}" && "${t}" ]] && echo -e "${red}Error:${clr} ${a[0]} invalid entry"
      continue
    }
    perlvar "${xpuiSpa}"
  done
}

xpui_detect() {
  [[ (-f "${appBak}" || -f "${xpuiBak}") && "${cleanAB}" ]] && {
    backup_spotx || {
      echo -e "\n${red}Error:${clr} Failed to create client backup. Exiting...\n" >&2
      exit 1
    }
    printf "\xE2\x9C\x94\x20\x43\x72\x65\x61\x74\x65\x64\x20\x62\x61\x63\x6B\x75\x70\n"
    return
  }
  [[ (-f "${appBak}" || -f "${xpuiBak}") && "${forceSpotx}" ]] && {
    { [[ ! -f "${appBak}" ]] || atomic_copy "${appBak}" "${appBinary}"; } &&
      { [[ ! -f "${xpuiBak}" ]] || atomic_copy "${xpuiBak}" "${xpuiSpa}"; } || {
      echo -e "\n${red}Error:${clr} Failed to restore client backup. Exiting...\n" >&2
      exit 1
    }
    printf "\xE2\x9C\x94\x20\x44\x65\x74\x65\x63\x74\x65\x64\x20\x26\x20\x72\x65\x73\x74\x6F\x72\x65\x64\x20\x62\x61\x63\x6B\x75\x70\n"
    return
  }
  [[ (-f "${appBak}" || -f "${xpuiBak}") && -z "${forceSpotx+x}" ]] && {
    rm -rf "${xpuiDir}" 2>/dev/null
    xpuiSkip='true'
    printf "\xE2\x9C\x94\x20\x44\x65\x74\x65\x63\x74\x65\x64\x20\x62\x61\x63\x6B\x75\x70\n"
    echo -e "\n${yellow}Warning:${clr} SpotX-Bash has already been installed." >&2
    echo -e "Use the '-f' flag to force SpotX-Bash to run.\n" >&2
    return
  }
  backup_spotx || {
    echo -e "\n${red}Error:${clr} Failed to create client backup. Exiting...\n" >&2
    exit 1
  }
  printf "\xE2\x9C\x94\x20\x43\x72\x65\x61\x74\x65\x64\x20\x62\x61\x63\x6B\x75\x70\n"
}

snapshot_check() {
  START_XM="76006100720020005F005F007700650062007000610063006B005F006D006F00640075006C00650073005F005F003D007B00"
  END_XM="78007000750069002D006D006F00640075006C00650073002E006A0073002E006D0061007000"
  
  [[ ! -f "${xpuiJs}" ]] && [[ -f "${xpuiSnapshotJs}" ]] && {
    [[ "${debug}" ]] && printf "\xE2\x9C\x94\x20\x44\x65\x74\x65\x63\x74\x65\x64\x20\x53\x6E\x61\x70\x73\x68\x6F\x74${clr}\n"
    
    perl -e '
      use strict; 
      use warnings; 
      use Encode qw(decode); 
      
      open my $in_fh, "<:raw", $ARGV[0] or die; 
      binmode $in_fh; 
      my $bin_content; 
      { local $/; $bin_content = <$in_fh>; } 
      close $in_fh; 
      
      die unless (length($bin_content) >= 2 && substr($bin_content, 0, 2) eq "\xFF\xFE") || 
                 (length($bin_content) > 100 && substr($bin_content, 1, 1) eq "\x00"); 
                 
      my $start_marker = pack("H*", $ARGV[1]); 
      my $end_marker = pack("H*", $ARGV[2]); 
      
      my $start_idx = index($bin_content, $start_marker, 2); 
      die if $start_idx == -1; 
      
      my $end_idx = index($bin_content, $end_marker, $start_idx + length($start_marker)); 
      die if $end_idx == -1; 
      
      my $extracted = substr($bin_content, $start_idx, $end_idx - $start_idx + length($end_marker)); 
      my $decoded = decode("UTF-16LE", $extracted); 
      
      open my $out_fh, "+<:encoding(UTF-8)", $ARGV[3] or die; 
      my $existing_content; 
      { local $/; $existing_content = <$out_fh>; } 
      seek $out_fh, 0, 0; 
      
      print $out_fh $decoded, "\n", $existing_content; 
      truncate $out_fh, tell($out_fh); 
      close $out_fh;
    ' "${snapshotBinary}" "${START_XM}" "${END_XM}" "${xpuiSnapshotJs}" || {
      uninstall_spotx
      echo -e "\n${red}Error:${clr} Snapshot processing failed\n" >&2
      exit 1
    }
    
    xpuiCss="${xpuiDir}/xpui-snapshot.css"
    xpuiJs="${xpuiSnapshotJs}"
  }
}

xpui_open() {
  rm -rf "${xpuiDir}" 2>/dev/null
  mkdir -p "${xpuiDir}"
  xpuiTempCreated='true'
  unzip -qq "${xpuiSpa}" -d "${xpuiDir}" || {
    rm -rf "${xpuiDir}" 2>/dev/null
    echo -e "\n${red}Error:${clr} Failed to unpack xpui.spa. Reinstall client. Exiting...\n" >&2
    exit 1
  }
  snapshot_check
  [[ "${versionFailed}" && -z "${forceVer+x}" || -z "${forceVer+x}" && "${debug}" && "${devMode}" && "${t}" ]] && {
    clientVer=$(perl -ne '/[Vv]ersion[:=,\x22]{1,3}(1\.[0-9]+\.[0-9]+\.[0-9]+)\.g[0-9a-f]+/ && print "$1"' "${xpuiJs}")
    [[ -z "${clientVer}" && "${debug}" && "${devMode}" && "${t}" ]] && {
      uninstall_spotx
      echo -e "${red}Error:${clr} Empty client version\n" >&2
      exit 1
    }
    [[ -z "${clientVer}" ]] && {
      clientVer="${sxbVer}"
      unknownVer='true'
      echo -e "\n${red}Warning:${clr} Client version not detected, some features may not be applied\n" >&2
    } || {
      (( $(ver "${clientVer}") < $(ver "1.1.59.710") )) && {
        uninstall_spotx
        echo -e "\n${red}Error:${clr} ${clientVer} not supported by SpotX-Bash\n" >&2
        exit 1
      }
    }
    [[ -z "${unknownVer+x}" ]] && (( $(ver "${clientVer}") <= $(ver "${sxbVer}") && $(ver "${clientVer}") > $(ver "0") )) && printf "\xE2\x9C\x94\x20\x44\x65\x74\x65\x63\x74\x65\x64\x20\x53\x70\x6F\x74\x69\x66\x79\x20${green}${clientVer}${clr}\n"
    [[ -z "${unknownVer+x}" ]] && (( $(ver "${clientVer}") > $(ver "${sxbVer}") )) && printf "\xE2\x9C\x94\x20\x44\x65\x74\x65\x63\x74\x65\x64\x20\x53\x70\x6F\x74\x69\x66\x79\x20${red}${clientVer}${clr}\n"
  }
  grep -Fq "SpotX" "${xpuiJs}" && {
    rm -rf "${xpuiBak}" "${xpuiDir}" 2>/dev/null
    echo -e "\n${red}Error:${clr} Detected SpotX-Bash but no backup file! Reinstall client. Exiting...\n" >&2
    exit 1
  }
}

run_core_start() {
  final_setup_check
  check_write_permission "${appPath}" "${appBinary}" "${xpuiPath}" "${xpuiSpa}"
  [[ "${platformType}" == "Linux" && "${stagedInstall}" ]] && protected_stage_prepare
  xpui_detect
  [[ "${xpuiSkip}" ]] && { printf "\xE2\x9C\x94\x20\x46\x69\x6E\x69\x73\x68\x65\x64\n\n"; exit 0; }
  xpui_open
  (($(ver "${clientVer}") > $(ver "1.2.56.9999"))) && vendorXpuiJs="${xpuiJs}"
}

run_patches() {
  perlVar "${aoEx[@]}"
  [[ "${paidPremium}" ]] && printf "\xE2\x9C\x94\x20\x44\x65\x74\x65\x63\x74\x65\x64\x20\x70\x72\x65\x6D\x69\x75\x6D\x2D\x74\x69\x65\x72\x20\x70\x6C\x61\x6E\n" || {
    perlVar "${freeEx[@]}"
    printf '\n%s\n%s\n%s\n%s\n%s' "${hideDLIcon}" "${hideDLMenu}" "${hideDLMenu2}" "${hideDLQual}" "${hideVeryHigh}"  >> "${xpuiCss}"
    printf "\xE2\x9C\x94\x20\x41\x70\x70\x6C\x69\x65\x64\x20\x66\x72\x65\x65\x2D\x74\x69\x65\x72\x20\x70\x6C\x61\x6E\x20\x70\x61\x74\x63\x68\x65\x73\n"
  }
  [[ "${devMode}" ]] && (($(ver "${clientVer}") >= $(ver "1.1.84.716"))) && {
    perlVar "${devEx[@]}"
    printf "\xE2\x9C\x94\x20\x45\x6E\x61\x62\x6C\x65\x64\x20\x64\x65\x76\x65\x6C\x6F\x70\x65\x72\x20\x6D\x6F\x64\x65\n"
  }
  [[ "${excludeExp}" ]] && printf "\xE2\x9C\x94\x20\x53\x6B\x69\x70\x70\x65\x64\x20\x65\x78\x70\x65\x72\x69\x6D\x65\x6E\x74\x61\x6C\x20\x66\x65\x61\x74\x75\x72\x65\x73\n" || {
    perlVar "${expEx[@]}"
    [[ "${paidPremium}" ]] && perlVar "${premiumExpEx[@]}"
    [[ -z "${hideNonMusic+x}" ]] && $perlVar 's|Enable Subfeed filter chips on home",default:\K!1|true|s' "${xpuiJs}" #enableHomeSubfeeds 1.2.20.1210
    printf "\xE2\x9C\x94\x20\x45\x6E\x61\x62\x6C\x65\x64\x20\x65\x78\x70\x65\x72\x69\x6D\x65\x6E\x74\x61\x6C\x20\x66\x65\x61\x74\x75\x72\x65\x73\n"
  }
  [[ "${oldUi}" ]] && {
    perlVar "${oldUiEx[@]}"
    (($(ver "${clientVer}") >= $(ver "1.1.93.896") && $(ver "${clientVer}") <= $(ver "1.2.13.661"))) && printf "\xE2\x9C\x94\x20\x45\x6E\x61\x62\x6C\x65\x64\x20\x6F\x6C\x64\x20\x55\x49\n"
    (($(ver "${clientVer}") > $(ver "1.2.13.661"))) && {
      unset oldUi
      echo -e "\n${yellow}Warning:${clr} Old UI not supported in clients after v1.2.13.661...\n" >&2
    }
  }
  [[ -z "${oldUi+x}" ]] && (($(ver "${clientVer}") >= $(ver "1.1.93.896"))) && {
    perlVar "${newUiEx[@]}"
    (($(ver "${clientVer}") <= $(ver "1.2.13.661"))) && printf "\xE2\x9C\x94\x20\x45\x6E\x61\x62\x6C\x65\x64\x20\x6E\x65\x77\x20\x55\x49\n"
  }
  [[ "${hideNonMusic}" ]] && (($(ver "${clientVer}") >= $(ver "1.1.70.610"))) && {
    perlVar "${podEx[@]}"
    (($(ver "${clientVer}") >= $(ver "1.2.45.451"))) && printf '\n%s' "${hideSubfeed}" >> "${xpuiCss}"
    printf "\xE2\x9C\x94\x20\x52\x65\x6D\x6F\x76\x65\x64\x20\x6E\x6F\x6E\x2D\x6D\x75\x73\x69\x63\x20\x63\x61\x74\x65\x67\x6F\x72\x69\x65\x73\x20\x6F\x6E\x20\x68\x6F\x6D\x65\x20\x73\x63\x72\x65\x65\x6E\n"
  }
  [[ "${lyricsBg}" ]] && {
    (($(ver "${clientVer}") >= $(ver "1.2.0.1165"))) && {
      perlVar "${lyricsBgEx[@]}"
      (($(ver "${clientVer}") >= $(ver "1.2.45.454"))) && printf '\n%b' "${lyricsBackgroundNew}" >> "${xpuiCss}"
      printf "\xE2\x9C\x94\x20\x45\x6E\x61\x62\x6C\x65\x64\x20\x62\x6C\x61\x63\x6B\x20\x62\x61\x63\x6B\x67\x72\x6F\x75\x6E\x64\x20\x66\x6F\x72\x20\x6C\x79\x72\x69\x63\x73\n"
    } || {
      echo -e "\n${yellow}Warning:${clr} Black lyrics background is not supported in this version...\n" >&2
    }
  }
  [[ "${blockUpdates}" ]] && {
    perlVar "${updatesEx[@]}"
    printf "\xE2\x9C\x94\x20\x42\x6C\x6F\x63\x6B\x65\x64\x20\x61\x75\x74\x6F\x6D\x61\x74\x69\x63\x20\x75\x70\x64\x61\x74\x65\x73\n"
  }
}

run_finish() {
  local spaTemp
  echo -e "\n//# SpotX was here" >> "${xpuiJs}"
  spaTempDir=$(mktemp -d "${xpuiPath}/.spotx-spa.XXXXXXXX") || {
    uninstall_spotx && \
      echo -e "\n${red}Error:${clr} Failed to create temporary SPA directory. Original client restored.\n" >&2 || \
      echo -e "\n${red}Error:${clr} Failed to create temporary SPA directory or restore client. Backups were preserved.\n" >&2
    exit 1
  }
  spaTemp="${spaTempDir}/xpui.spa"
  (cd "${xpuiDir}" && zip -qq -r "${spaTemp}" .) &&
    unzip -tqq "${spaTemp}" &&
    mv -f "${spaTemp}" "${xpuiSpa}" || {
    rm -rf "${spaTempDir}" 2>/dev/null
    uninstall_spotx && {
      echo -e "\n${red}Error:${clr} Failed to repackage client." >&2
      echo -e "Original client restored.\n" >&2
    } || {
      echo -e "\n${red}Error:${clr} Failed to repackage or restore client." >&2
      echo -e "Backups were preserved.\n" >&2
    }
    exit 1
  }
  rm -rf "${spaTempDir}" 2>/dev/null
  [[ ! -d "${spaTempDir}" ]] && unset spaTempDir
  rm -rf "${xpuiDir}"
  unset xpuiTempCreated
  [[ "${platformType}" == "Linux" && "${stagedInstall}" ]] && protected_commit || {
    [[ "${platformType}" == "Linux" && "${stagedInstall}" ]] && {
      echo -e "\n${red}Error:${clr} Failed to install patched client. Original files restored.\n" >&2
      exit 1
    }
  }
  [[ "${platformType}" == "macOS" ]] && {
    macos_codesign
  }
}

perlVar="perl -0777pi -w -e"
hideDLIcon=' .BKsbV2Xl786X9a09XROH, .GWCBhKJqeZal3n5tCQwl, .pX3IkLhEry0wVfiU {display:none}'
hideDLMenu=' button.wC9sIed7pfp47wZbmU6m.pzkhLqffqF_4hucrVVQA, button.dx1wWcqtuxz4HubHAyh_.tT_JypfxNakuY1jHgyBN, button.KzLH25pAEr43wpSc.zVA1h9TUy8QQBogj {display:none}'
hideDLMenu2=' .pzkhLqffqF_4hucrVVQA, .egE6UQjF_UUoCzvMxREj, .Y98_oiegQgSpY_o7hoKG {display:none}'
hideDLQual=' :is(.weV_qxFz4gF5sPotO10y, .BMtRRwqaJD_95vJFMFD0, .eguwzH_QWTBXry7hiNj3, .qV_CxbowaNkMarye):has([for="desktop.settings.downloadQuality"]) {display: none}'
hideSubfeed=' .cj6vRk3nFAi80HSVqX91, .c8Z2jJUocJTdV9g741cp, .x_HLN829yDsvJDgl {display:none}'
hideVeryHigh=' #desktop\.settings\.streamingQuality>option:nth-child(5) {display:none}'
lyricsBackgroundNew=' .FUYNhisXTCmbzt9IDxnT,\n .tr8V5eHsUaIkOYVw7eSG,\n .hW9km7ku6_iggdWDR_Lg,\n .lofIAg8Ixko3mfBrbfej,\n .bbJIIopLxggQmv5x,\n .Li269NgzkU2gI4KOP9sM,\n .I2WIloMMjsBeMaIS8H3v,\n .McI3hD7aCfpq015LJa6X,\n .gpDSOimnzH4zTJmE7UR5 {\n \t--lyrics-color-active: #C8C8C8 !important;\n \t--lyrics-color-inactive: #575757 !important;\n \t--lyrics-color-passed: #575757 !important;\n \t--lyrics-color-background: #121212 !important;\n }'
updatesEx=(
'blockUpdates&\x64(?=\x65\x73\x6B\x74\x6F\x70\x2D\x75\x70)&\x00&g&appBinary&1.1.70.610&9.9.9.9&macOS'
)
freeEx=(
'adsB&/a\Kd(?=s/v1)|/a\Kd(?=s/v2/t)|/a\Kd(?=s/v2/se)&b&gs&appBinary&1.1.59.710&1.2.64.408'
'adsX&/a\Kd(?=s/v1)|/a\Kd(?=s/v2/t)|/a\Kd(?=s/v2/se)&b&gs&xpuiJs&1.1.59.710&1.2.60.564'
'adsX2&}/a\Kd(?=s)&b&gs&xpuiJs&1.2.55.235'
'adsBillboard&.(?=\?\[.{1,6}[a-zA-Z].leaderboard,)&false&&xpuiJs&1.1.59.710&1.2.6.863'
'adConfig&/\Kv2/config&config&gs&xpuiJs&1.2.55.235'
'adsCosmos&(case .:|async enable\(.\)\{)(this.enabled=.+?\(.{1,3},"audio"\),|return this.enabled=...+?\(.{1,3},"audio"\))((;case 4:)?this.subscription=this.audioApi).+?this.onAdMessage\)&$1$3.cosmosConnector.increaseStreamTime(-100000000000)&&xpuiJs&1.1.59.710&1.1.92.647'
'adsEmptyBlock&adsEnabled:!\K0&1&&xpuiJs'
'connectOld1& connect-device-list-item--disabled&&&xpuiJs&1.1.70.610&1.1.90.859'
'connectOld2&connect-picker.unavailable-to-control&spotify-connect&&xpuiJs&1.1.70.610&1.1.90.859'
'connectOld3&("button",\{className:.,disabled:)(..)&$1false&&xpuiJs&1.1.70.610&1.1.90.859'
'connectNew&return (..isDisabled)(\?(..createElement|\(.{1,10}\))\(..,)&return false$2&&xpuiJs&1.1.91.824&1.1.92.647'
'enableImprovedDevicePickerUI1&Enable showing a new and improved device picker UI",default:\K!.(?=})&true&&xpuiJs&1.1.91.824&1.1.92.647'
'esperantoProductState&(this\.(?:productStateApi|_product_state)(?:|_service)=(.))(?=}|(?:,.{1,30})?,this\.productStateApi|,this\._events)&$1,$2.putOverridesValues({pairs:{ads:'\''0'\'',catalogue:'\''premium'\'',type:'\''premium'\'',name:'\''Spotify'\''}})&&xpuiJs'
'hideDlQual&(\(.,..jsxs\)\(.{1,3}|(.\(\).|..)createElement\(.{1,4}),\{(filterMatchQuery|filter:.,title|(variant:"viola",semanticColor:"textSubdued"|..:"span",variant:.{3,6}mesto,color:.{3,6}),htmlFor:"desktop.settings.downloadQuality.+?).{1,6}get\("desktop.settings.downloadQuality.title.+?(children:.{1,2}\(.,.\).+?,|\(.,.\){3,4},|,.\)}},.\(.,.\)\),)&&&xpuiJs&1.1.59.710&1.2.29.605'
'hideUpgradeButton&(return|.=.=>)"free"===(.+?)(return|.=.=>)"premium"===&$1"premium"===$2$3"free"===&g&xpuiJs&1.1.59.710&1.1.92.647'
'hideUpgradeButton2&(?|(===")free(")|(")free("===))&$1premium$2&g&xpuiJs&1.2.55.235'
'hptoEnabled&hptoEnabled:!\K0&1&s&xpuiJs&&1.2.94.583'
'hptoShown&isHptoShown:!\K0&1&gs&homeHptoJs&1.1.85.884&1.2.20.1218'
'hptoShown2&(ADS_PREMIUM,isPremium:)\w(.*?ADS_HPTO_HIDDEN,isHptoHidden:)\w&$1true$2true&&xpuiJs&1.2.21.1104'
'payloadS&\x3F\x70\x61\x79\x6C\x6F\x61\x64&\x00\x00\x00\x00\x00\x00\x00\x00&gs&appBinary&1.2.53.437&1.2.93.667'
'stateS1&\x69\x6E\x69\x74\x69\x61\x6C\x5F(?=\x48)&\x00\x00\x00\x00\x00\x00\x00\x00&s&appBinary&1.2.53.437&1.2.55.235&macOS'
'stateS2&\x69\x6E\x69\x74\x69\x61\x6C\x5F(?=\x48)&\x00\x00\x00\x00\x00\x00\x00\x00&s&appBinary&1.2.53.437&1.2.84.476&Linux'
'stateS3&[\x00\x0A\x1A]\K\x69\x6E\x69\x74\x69\x61\x6C\x5F(?=\x73\x74\x61\x74\x65\x00)&\x00\x00\x00\x00\x00\x00\x00\x00&s&appBinary&1.2.55.235&&macOS'
'stateS4&[\x00\x0A\x1A]\K\x69\x6E\x69\x74\x69\x61\x6C\x5F(?=\x73\x74\x61\x74\x65\x00)&\x00\x00\x00\x00\x00\x00\x00\x00&s&appBinary&1.2.86.502&&Linux'
)
devEx=(
'dev1&[\x00\xFF][\x00\xFF]\x48\xB8\x65\x76\x65\x6C.{4}\x48.{36,50}\K\xE8.{4}&\xB8\x03\x00\x00\x00&gs&appBinary&1.1.84.716'
'dev2&\xF8\xFF[\x37\x77\xB7\xF7][\x06-\x0F\x10-\x19]\x39\xFF.[\x00-\x04]\xB9\xE1[\x03\x43\x83\xC3][\x06-\x0F\x10-\x19]\x91\xE2.[\x02-\x0F\x13]\x91.{0,4}\K...[\x94\x97](?=[\xF0-\xFF]\x03)&\x60\x00\x80\xD2&s&appBinary&1.1.84.716&&macOS'
'devDebug&(return ).{1,3}(\?(?:.{1,4}createElement|\(.{1,7}.jsxs\)))(\(.{3,7}\{displayText:"Debug Tools"(?:,children.{3,8}jsx\)|},.\.createElement))(\(.{4,6}role.*?Debug Window".*?\))(.*?Locales.{3,8})(:null)&$1true$2$4$6&&xpuiJs&1.1.92.644&1.2.59.518'
'enableDebugTools&debug tools and features for employees",default:\K!1&true&s&xpuiJs&1.2.60.564'
)
oldUiEx=(
'disableYLXSidebar&Enable Your Library X view of the left sidebar",default:\K!.(?=})&false&s&xpuiJs&1.1.93.896&1.2.13.661'
'disableRightSidebar&Enable the view on the right sidebar",default:\K!.(?=})&false&s&xpuiJs&1.1.93.896&1.2.13.661'
)
newUiEx=(
'enableNavAltExperiment&Enable the new home structure and navigation",values:.,default:\K..DISABLED&true&&xpuiJs&1.1.94.864&1.1.96.785'
'enableNavAltExperiment2&Enable the new home structure and navigation",values:.,default:.\K.DISABLED&.ENABLED_CENTER&&xpuiJs&1.1.97.956&1.2.2.582'
'enablePanelSizeCoordination&Enable Panel Size Coordination between the left sidebar, the main view and the right sidebar",default:\K!.(?=})&true&s&xpuiJs&1.2.7.1264&1.2.50.335'
'enableRightSidebar&Enable the view on the right sidebar",default:\K!1&true&s&xpuiJs&1.1.98.683&1.2.93.667'
'enableRightSidebarLyrics&Show lyrics in the right sidebar",default:\K!1&true&s&xpuiJs&1.2.0.1165&1.2.94.583'
'enableYLXSidebar&Enable Your Library X view of the left sidebar",default:\K!1&true&s&xpuiJs&1.1.97.962&1.2.13.661'
)
podEx=(
'hidePodcasts&withQueryParameters\(.\)\{return this.queryParameters=.,this}&withQueryParameters(e){return this.queryParameters=(e.types?{...e, types: e.types.split(",").filter(_ => !["episode","show"].includes(_)).join(",")}:e),this}&&xpuiJs&1.1.70.610&1.1.85.895'
'hidePodcasts2&(case 6:|const .=await .\([^\)]*\);)((return .\.abrupt\(\"|return[ \"],?)(null!=n\x26\x26|return\",)?(.)(\);case 9|\??.errors\?.*?Promise.reject.+?errors\)+:.))&$1$5?.data?.home?.sectionContainer?.sections?.items?.forEach(x => x?.sectionItems?.items \x26\x26 (x.sectionItems.items = x.sectionItems.items.filter(i => !['\''Podcast'\'','\''Audiobook'\'','\''Episode'\''].includes(i?.content?.data?.__typename))));$2&&xpuiJs&1.1.86.857&1.2.85.519'
'hidePodcasts3&(try\{let (.)=await [^\(]+\([^\)]*\);)(if\(.\?\.errors\)return[\s\S]+?Promise\.reject\(.\?\.errors\);return .\}catch\(.\))&$1$2?.data?.home?.sectionContainer?.sections?.items?.forEach(x => x?.sectionItems?.items \x26\x26 (x.sectionItems.items = x.sectionItems.items.filter(i => !['\''Podcast'\'','\''Audiobook'\'','\''Episode'\''].includes(i?.content?.data?.__typename))));$3&&xpuiJs&1.2.86.502'
)
lyricsBgEx=(
'lyricsBackground1&--lyrics-color-inactive":\K(.).inactive&$1.background&&xpuiJs&1.2.0.1165&1.2.44.405'
'lyricsBackground2&--lyrics-color-background":\K(.).background&$1.inactive&&xpuiJs&1.2.0.1165&1.2.44.405'
'lyricsBackground3&--lyrics-color-inactive":\K(.\.colors).text&$1.background&&xpuiJs&1.2.0.1165&1.2.44.405'
'lyricsBackground4&--lyrics-color-background":\K(.\.colors).background&$1.text&&xpuiJs&1.2.0.1165&1.2.44.405'
)
aoEx=(
'aboutSpotX&((..createElement|children:\(.{1,7}\))\(.{1,7},\{source:).{1,7}get\("about.copyright",.\),paragraphClassName:("[^"]+"|.)(?=\}\))&$1"<h3>About SpotX / SpotX-Bash</h3><br><details><summary><svg xmlns='\''http://www.w3.org/2000/svg'\'' width='\''20'\'' height='\''20'\'' viewBox='\''0 0 24 24'\''><path d='\''M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z'\'' fill='\''#fff'\''/></svg> Github</summary><a href='\''https://github.com/SpotX-Official/SpotX'\''>SpotX \(Windows\)</a><br><a href='\''https://github.com/SpotX-Official/SpotX-Bash'\''>SpotX-Bash \(Linux/macOS\)</a><br><br/></details><details><summary><svg xmlns='\''http://www.w3.org/2000/svg'\'' width='\''20'\'' height='\''20'\'' viewBox='\''0 0 24 24'\''><path id='\''telegram-1'\'' d='\''M18.384,22.779c0.322,0.228 0.737,0.285 1.107,0.145c0.37,-0.141 0.642,-0.457 0.724,-0.84c0.869,-4.084 2.977,-14.421 3.768,-18.136c0.06,-0.28 -0.04,-0.571 -0.26,-0.758c-0.22,-0.187 -0.525,-0.241 -0.797,-0.14c-4.193,1.552 -17.106,6.397 -22.384,8.35c-0.335,0.124 -0.553,0.446 -0.542,0.799c0.012,0.354 0.25,0.661 0.593,0.764c2.367,0.708 5.474,1.693 5.474,1.693c0,0 1.452,4.385 2.209,6.615c0.095,0.28 0.314,0.5 0.603,0.576c0.288,0.075 0.596,-0.004 0.811,-0.207c1.216,-1.148 3.096,-2.923 3.096,-2.923c0,0 3.572,2.619 5.598,4.062Zm-11.01,-8.677l1.679,5.538l0.373,-3.507c0,0 6.487,-5.851 10.185,-9.186c0.108,-0.098 0.123,-0.262 0.033,-0.377c-0.089,-0.115 -0.253,-0.142 -0.376,-0.064c-4.286,2.737 -11.894,7.596 -11.894,7.596Z'\'' fill='\''#fff'\''/></svg> Telegram</summary><a href='\''https://t.me/spotify_windows_mod'\''>SpotX Channel</a><br><a href='\''https://t.me/SpotxCommunity'\''>SpotX Community</a><br><br/></details><details><summary><svg xmlns='\''http://www.w3.org/2000/svg'\'' width='\''20'\'' height='\''20'\'' viewBox='\''0 0 24 24'\''><path d='\''M12 2c5.514 0 10 4.486 10 10s-4.486 10-10 10-10-4.486-10-10 4.486-10 10-10zm0-2c-6.627 0-12 5.373-12 12s5.373 12 12 12 12-5.373 12-12-5.373-12-12-12zm1.25 17c0 .69-.559 1.25-1.25 1.25-.689 0-1.25-.56-1.25-1.25s.561-1.25 1.25-1.25c.691 0 1.25.56 1.25 1.25zm1.393-9.998c-.608-.616-1.515-.955-2.551-.955-2.18 0-3.59 1.55-3.59 3.95h2.011c0-1.486.829-2.013 1.538-2.013.634 0 1.307.421 1.364 1.226.062.847-.39 1.277-.962 1.821-1.412 1.343-1.438 1.993-1.432 3.468h2.005c-.013-.664.03-1.203.935-2.178.677-.73 1.519-1.638 1.536-3.022.011-.924-.284-1.719-.854-2.297z'\'' fill='\''#fff'\''/></svg> FAQ</summary><a href='\''https://te.legra.ph/SpotX-FAQ-09-19'\''>Windows</a><br><a href='\''https://github.com/SpotX-Official/SpotX-Bash/wiki/SpotX%E2%80%90Bash-FAQ'\''>Linux/macOS</a></details><br><h4>DISCLAIMER</h4>SpotX is a modified version of the official Spotify\x26reg; client, provided \x26quot;as is\x26quot; for the purpose of evaluation at user'\''s own risk. Source code for SpotX is available separately and free of charge under open source software license agreements. SpotX is not affiliated with Spotify\x26reg;, Spotify AB or Spotify Group.<br><br>Spotify\x26reg; is a registered trademark of Spotify Group."&&xpuiDesktopModalsJs&1.1.79.763'
'allowSwitchingBetweenHomeAdsAndHpto&opposed to only showing the legacy HPTO format.",default:\K!.(?=})&false&s&xpuiJs&1.2.34.783&1.2.94.583'
'betamaxFilterNegativeDuration&for duration that is negative",default:\K!.(?=})&false&s&xpuiJs&1.1.59.001&1.2.93.667'
'bGabo&\x00\K\x67(?=\x61\x62\x6F\x2D\x72\x65\x63\x65\x69\x76\x65\x72\x2D\x73\x65\x72\x76\x69\x63\x65\x2F\x70)&\x00&g&appBinary&1.1.84.716'
'bLogic&\x00\K\x61(?=\x64\x2D\x6C\x6F\x67\x69\x63\x2F\x73)&\x00&&appBinary&1.1.70.610&1.2.28.581'
'bSlot&\x00\K\x73(?=\x6C\x6F\x74\x73\x00)&\x00&g&appBinary&1.1.70.610'
'disablePremiumOnlyModal&Disable the Premium Only Modal",default:\K!.(?=})&true&s&xpuiJs&1.2.39.578&1.2.95.453'
'embeddedAdImpressionDoesNotIgnoreVisilibility&If enabled, we do consider percent visibility when logging the display ad impression.{0,49}",default:\K!.(?=})&false&s&xpuiJs&1.2.78.397&1.2.84.477'
'enable_ad_feedback_home_free&Kill switch for ad feedback on home ad format for free users",default:\K!.(?=})&false&s&xpuiJs&1.2.93.656'
'enable_ad_feedback_home_premium&Kill switch for ad feedback on home ad format for premium users",default:\K!.(?=})&false&s&xpuiJs&1.2.93.656'
'enable_ad_feedback_milestone_3&Enable ad feedback milestone 3 feature",default:\K!.(?=})&false&s&xpuiJs&1.2.93.656'
'enableAgeAssuranceComments&Enables the age assurance gating for comments feature",default:\K!.(?=})&false&s&xpuiJs&1.2.78.397'
'enableAgeAssuranceFriendActivity&Enables the age assurance gating for friend activity feed",default:\K!.(?=})&false&s&xpuiJs&1.2.78.397'
'enableAgeAssuranceProfileMenu&Enables the age assurance entry point in the profile menu .{0,43}",default:\K!.(?=})&false&s&xpuiJs&1.2.78.397'
'enableAgeAssuranceSettings&Enables the age assurance section in account settings",default:\K!.(?=})&false&s&xpuiJs&1.2.78.397'
'enableCanvasAds&Enable Canvas for ads",default:\K!.(?=})&false&s&xpuiJs&1.2.52.442&1.2.92.148'
'enableConnectedStateObserver&observer that logs errors related to connected state and ad info",default:\K!.(?=})&false&s&xpuiJs&1.2.53.437'
'enableCulturalMoments&Cultural Moment pagess",default:\K!.(?=})&false&s&xpuiJs&1.2.7.1264&1.2.50.335'
'enableDesktopMusicLeavebehinds&Enable music leavebehinds on eligible playlists for desktop",default:\K!.(?=})&false&s&xpuiJs&1.2.10.751&1.2.93.667'
'enableDsaAds&Enable showing DSA .Digital Services Act. context menu and modal for ads",default:\K!.(?=})&false&s&xpuiJs&1.2.20.1210&1.2.52.442'
'enableDSASetting&Enable DSA .Digital Service Act. features for desktop and web",default:\K!.(?=})&false&s&xpuiJs&1.2.20.1210'
'enableEnhancedAdsClientDeconfliction&Enable refactored version of ads orchestrator middleware",default:\K!.(?=})&false&s&xpuiJs&1.2.57.460&1.2.61.443'
'enableEmbeddedAdsCarousel&embedded ads carousel for the NPV",default:\K!.(?=})&false&s&xpuiJs&1.2.73.451'
'enableEmbeddedAdsFetchingOverCanvas&embedded ads fetching when canvas track is playing. Defaults to true since this is currently existing behavior",default:\K!.(?=})&false&s&xpuiJs&1.2.72.435&1.2.77.358'
'enableEmbeddedAdHtmlDisplay&Enable HTML display ads in the embedded NPV",default:\K!.(?=})&false&s&xpuiJs&1.2.94.0'
'enableEmbeddedAdVisibilityLogging&When enabled, enhanced visibility logs will be sent for embedded ads",default:\K!.(?=})&false&s&xpuiJs&1.2.64.407&1.2.77.358'
'enableEmbeddedNpvAds&Enable embedded display ads on NPV",default:\K!.(?=})&false&s&xpuiJs&1.2.57.460&1.2.77.358'
'enableEsperantoMigration&Enable esperanto Migration for (HPTO\s)?Ad Formats?",default:\K!.(?=})&false&s&xpuiJs&1.2.6.861&1.2.50.335'
'enableEsperantoMigrationLeaderboard&Enable esperanto Migration for Leaderboard Ad Format",default:\K!.(?=})&false&s&xpuiJs&1.2.32.985&1.2.91.9999'
'enableFraudLoadSignals&Enable user fraud signals emitted on page load",default:\K!.(?=})&false&s&xpuiJs&1.2.22.975&1.2.62.580'
'enableHomeAds&Enable Fist Impression Takeover ads on Home Page",default:\K!.(?=})&false&s&xpuiJs&1.2.31.1205&1.2.84.477'
'enableHomeAdStaticBanner&Enables temporary home banner, static version",default:\K!.(?=})&false&s&xpuiJs&1.2.25.1009&1.2.53.440'
'enableHpto&Hpto announcements on Home",default:\K!.(?=})&false&s&xpuiJs&1.2.65.255&1.2.94.583'
'enableHptoHarmonyVideoPlayer&Harmony-based video player for HPTO home video ads. replacing the Betamax player",default:\K!.(?=})&false&s&xpuiJs&1.2.96.200'
'enableHptoLayoutRewrite&Enable the new HomeAdCard flexbox layout rewrite",default:\K!.(?=})&false&s&xpuiJs&1.2.92.0'
'enableHptoLocationRefactor&Enable new permanent location for HPTO iframe to HptoHtml.js",default:\K!.(?=})&false&s&xpuiJs&1.2.1.958&1.2.20.1218'
'enableImageOptimizationSentrySpanMeasurement&Sentry image resource span attributes for image optimization rollout measurement",default:\K!.(?=})&false&s&xpuiJs&1.2.94.0'
'enableInAppMessaging&Enables quicksilver in-app messaging modal",default:\K!.(?=})&false&s&xpuiJs&1.1.70.610'
'enableInteractionLogger&Enables the old interaction logger",default:\K!.(?=})&false&s&xpuiJs&1.2.41.434&1.2.64.408'
'enableLeaderboardEmptySlotHandling&Config for clearing the current leaderboard ad and hiding the leaderboard container when the ad slot returns an empty response",default:\K!.(?=})&true&s&xpuiJs&1.2.95.200&1.2.97.270'
'enableLeavebehindsMockData&Use the mock endpoint to fetch Leavebehinds from AP4P",default:\K!.(?=})&false&s&xpuiJs&1.2.30.1135'
'enableNewAdsNpv&Enable showing new ads NPV",default:\K!.(?=})&false&s&xpuiJs&1.2.18.997&1.2.50.335'
'enableNewAdsNpvCanvasAds&Enable Canvas ads for new ads NPV",default:\K!.(?=})&false&s&xpuiJs&1.2.28.581&1.2.51.345'
'enableNewAdsNpvColorExtraction&Enable CTA card color extraction for new ads NPV",default:\K!.(?=})&false&s&xpuiJs&1.2.18.997&1.2.50.335'
'enableNewAdsNpvNewVideoTakeoverSlot&position redesigned new ads NPV VideoTakeover above all areas except RightSidebar and NPB ",default:\K!.(?=})&false&s&xpuiJs&1.2.22.975&1.2.50.335'
'enableNewAdsNpvVideoTakeover&Enable redesigned VideoTakeover for new ads NPV",default:\K!.(?=})&false&s&xpuiJs&1.2.18.997&1.2.50.335'
'enableNonUserTriggeredPopovers&Enables programmatically triggered popovers",default:\K!.(?=})&false&s&xpuiJs&1.2.23.1114'
'enablePickAndShuffle&pick and shuffle",default:\K!.(?=})&false&s&xpuiJs&1.1.85.884&1.2.42.290'
'enablePipImpressionLogging&Enables impression logging for PiP",default:\K!.(?=})&false&s&xpuiJs&1.2.32.985&1.2.78.418'
'enablePodcastSponsoredContent&Enable sponsored content information for podcasts",default:\K!.(?=})&false&s&xpuiJs&1.2.30.1135&1.2.50.335'
'enablePromotions&Enables promotions on home",default:\K!.(?=})&false&s&xpuiJs&1.2.38.720&1.2.45.454'
'enableSaxLeaderboardAds&Enable SAX Leaderboard Ad Format",default:\K!.(?=})&false&s&xpuiJs&1.2.62.575&1.2.82.428'
'enableSentryReactRouterV6Routing&Sentry React Router v6 route instrumentation for Web Player SPA transactions",default:\K!.(?=})&false&s&xpuiJs&1.2.94.0'
'enableShowLeavebehindConsolidation&Enable show leavebehinds consolidated experience",default:\K!.(?=})&false&s&xpuiJs&1.2.23.1114&1.2.93.667'
'enableSidekickFeedbackBanner&Show the feedback banner in the Sidekick chat",default:\K!.(?=})&false&s&xpuiJs&1.2.96.200'
'enableSponsoredPlaylistEsperantoMigration&Enable esperanto Migration for Sponsored Playlist Ad Formats",default:\K!.(?=})&false&s&xpuiJs&1.2.32.985&1.2.50.335'
'enableSponsoredPlaylistHorizontalVideo&horizontal video layout for sponsored playlist headers on desktop",default:\K!.(?=})&false&s&xpuiJs&1.2.95.200'
'enableSurveyAds&Enable Spotify Brand Lift .SBL. Surveys in the NPV",default:\K!.(?=})&false&s&xpuiJs&1.2.43.420&1.2.63.394'
'enableUnderAgeBlockingModal&Enables the underage blocking modal for accounts in blocked/pending disabled state",default:\K!.(?=})&false&s&xpuiJs&1.2.78.397'
'enableUserFraudCanvas&Enable user fraud Canvas Fingerprinting",default:\K!.(?=})&false&s&xpuiJs&1.2.13.656&1.2.63.394'
'enableUserFraudCspViolation&Enable CSP violation detection",default:\K!.(?=})&false&s&xpuiJs&1.2.17.832&1.2.62.580'
'enableUserFraudSignals&Enable user fraud signals",default:\K!.(?=})&false&s&xpuiJs&1.2.10.751&1.2.62.580'
'enableUserFraudVerification&Enable user fraud verification",default:\K!.(?=})&false&s&xpuiJs&1.2.3.1107&1.2.62.580'
'enableUserFraudVerificationRequest&Enable the IAV component make api requests",default:\K!.(?=})&false&s&xpuiJs&1.2.5.954&1.2.62.580'
'enableVideoAdTerminatedEvent&Fire terminated events for non-complete video ad endings on desktop",default:\K!.(?=})&false&s&xpuiJs&1.2.98.250'
'enableYourListeningUpsell&Enable Your Listening Upsell Banner for free . unauth users",default:\K!.(?=})&false&s&xpuiJs&1.2.25.1009&1.2.63.394'
'hideUpgradeCTA&Hide the Upgrade CTA button on the Top Bar",default:\K!.(?=})&true&s&xpuiJs&1.2.26.1180'
'homeV2Fix1&("HomeResponsePayload"[\s\S]{0,500}?)0\s*===\s*([A-Za-z_\$][\w\$]*)\.sectionContainer\.sections\.totalCount\s*\|\|\s*0\s*===\s*\2\.sectionContainer\.sections\.items\.length&$1!Array.isArray(null==$2||null==$2.sectionContainer||null==$2.sectionContainer.sections?void 0:$2.sectionContainer.sections.items)||0===$2.sectionContainer.sections.items.length&&homeV2Js&1.1.92.0&1.2.44.9999'
'leavebehinds&\/(?:leavebehinds\/mock|leavebehinds|mock|sponsoredplaylist)\/&/localhost/&g&xpuiJs&1.2.55.235'
'logSentry&(this\.getStackTop\(\)\.client=.)&return;$1&&vendorXpuiJs&1.1.70.610&1.2.29.605'
'logSentry2&sentry\.io&localhost.io&&xpuiJs&1.1.70.610'
'lUnsupported&((?:\(?await )?.\.build.{20,60}encodeURIComponent.{20,140}"\/track\/\{trackId\}.+?)(.send)&$1.withHeaders([{key:"spotify-app-version",value:"1.2.45.454"}])$2&s&xpuiJs&1.1.70.610&1.2.45.451'
'logV3&sp://logging/v3/\w+&&g&xpuiJs&1.1.70.610'
're1&\xE8...[\xFE\xFF]\x4D\x8B.{1,2}\x4D\x85.\x75[\xA0-\xAF]\x48\x8D.{9,10}\K\xE8...[\xFE\xFF](?=[\x40-\x4F][\x80-\x8F])&\x0F\x1F\x44\x00\x00&gs&appBinary&1.2.29.605&&Linux&&2'
're2&\x24\x24\x4D\x85\xE4\x75\xA9\x48\x8D\x35...\x01\x48\x8D\xBD.[\xFE\xFF]\xFF\xFF\K\xE8....&\x0F\x1F\x44\x00\x00&gs&appBinary&1.2.29.605&&macOS&&2'
're3&[\x10-\x1F]\x01\x00\x39.{0,4}\xE0\x03[\x10-\x1F]\xAA...[\x90-\x9F].[\x02\x03]\x40\xF9[\x70-\x7F]\xFD\xFF\xB5..\x00.\x21..\x91\xE0.[\x00-\x0F]\x91\K....(?=[\xF0-\xFF][\x00-\x0F]....\x00)&\x1F\x20\x03\xD5&gs&appBinary&1.2.29.605&&macOS&&2'
'searchFix1&(typeName])&$1 || []&s&xpuiJs&1.2.28.581&1.2.57.463'
'slotMid&\x70\x6F\x64\x63\x61\x73\x74\K\x2D\x6D\x69&\x20\x6D\x69&g&appBinary&1.0.29.605&1.0.29.605&macOS'
'slotPost&\x70\x6F\x64\x63\x61\x73\x74\K\x2D\x70\x6F&\x20\x70\x6F&g&appBinary&1.0.29.605&1.0.29.605&macOS'
'slotPre&\x2D(?=\x70\x72\x65\x72\x6F\x6C\x6C)&\x20&g&appBinary&1.0.29.605&1.0.29.605&macOS'
'sponsors1&ht.{14}\...\..{7}\....\/.{8}ap4p\/&&g&xpuiJs&1.1.70.610&1.2.52.442'
'sponsors2&ht.{14}\...\..{7}\....\/s.{15}t\/v.\/&&g&xpuiJs&1.1.70.610&1.2.60.564'
'sponsors3&allSponsorships&&g&xpuiJs&1.1.59.710'
'sponsors4&\/\K.{7}-ap4p&&g&xpuiJs&1.2.53.437'
'ucsC&\x00\K\x68(?=.{30}\x2F\x75\x73\x65\x72\x2D)&\x00&s&appBinary&1.2.55.235'
'useAdsSurfaceStateForAdOrchestration&Use ads-owned NPV and cinema surface state for ad orchestration",default:\K!.(?=})&false&s&xpuiJs&1.2.96.200'
'webgateGabo&\@webgate\/(gabo)&"@" . $1&ge&vendorXpuiJs&1.1.70.610'
'webgateRemote&\@webgate\/(remote)&"@" . $1&ge&vendorXpuiJs&1.1.70.610'
)
expEx=(
'enableAddPlaylistToPlaylist&support for adding a playlist to another playlist",default:\K!1&true&s&xpuiJs&1.1.98.683&1.2.3.1115'
'enableAiDubbedEpisodesInNpv&showing AI dubbed episodes in NPV",default:\K!.(?=})&true&s&xpuiJs&1.2.28.581&1.2.50.335'
'enableAlbumCoverArtModal&cover art modal on the Album page",default:\K!.(?=})&true&s&xpuiJs&1.2.13.656&1.2.50.335'
'enableAlbumPrerelease&album prerelease pages",default:\K!.(?=})&true&s&xpuiJs&1.2.18.997&1.2.50.335'
'enableAlbumReleaseAnniversaries&balloons on album release date anniversaries",default:\K!1&true&s&xpuiJs&1.1.89.854'
'enableAlignedCuration&Aligned Curation",default:\K!.(?=})&false&s&xpuiJs&1.2.21.1104&1.2.50.335'
'enableAlignedPanelHeaders&aligned panel headers",default:\K!1&true&s&xpuiJs&1.2.57.460&1.2.62.580'
'enableAnonymousVideoPlayback&anonymous users to play video podcasts",default:\K!1&true&s&xpuiJs&1.2.29.605&1.2.78.418'
'enableArtistBans&feature to ban/unban artists and have the UI reflect it",default:\K!.(?=})&true&s&xpuiJs&1.2.43.420&1.2.50.335'
'enableArtistLikedSongs&Liked Songs section on Artist page",default:\K!1&true&s&xpuiJs&1.1.59.710&1.2.17.834'
'enableAttackOnTitanEasterEgg&Titan Easter egg turning progress bar red when playing official soundtrack",default:\K!.(?=})&true&s&xpuiJs&1.2.6.861&1.2.50.335'
'enableAudiobookPrerelease&audiobook prerelease pages",default:\K!1&true&s&xpuiJs&1.2.33.1039&1.2.47.366'
'enableAudiobooks&Audiobooks feature on ClientX",default:\K!1&true&s&xpuiJs&1.1.74.631&1.2.46.462'
'enableAutoSeekToVideoBufferedStartPosition&avoid initial seek if the initial position is not buffered",default:\K!1&true&s&xpuiJs&1.2.31.1205&1.2.93.667'
'enableBackendSearchHistory&Enable backend search history",default:\K!1&true&s&xpuiJs&1.2.60.564&1.2.85.519'
'enableBanArtistAction&context menu action to ban/unban artists",default:\K!1&true&s&xpuiJs&1.2.28.581&1.2.42.290'
'enableBetamaxSdkSubtitlesDesktopX&rendering subtitles on the betamax SDK on DesktopX",default:\K!.(?=})&true&s&xpuiJs&1.1.70.610'
'enableBillboardEsperantoMigration&esperanto migration for Billboard Ad Format",default:\K!.(?=})&true&s&xpuiJs&1.2.32.985&1.2.52.442'
'enableBLEJamBroadcasting&Jam Broadcasting for Bluetooth",default:\K!1&true&s&xpuiJs&1.2.76.256'
'enableBlockUsers&block users feature in clientX",default:\K!.(?=})&true&s&xpuiJs&1.1.70.610&1.2.50.335'
'enableBrowseViaPathfinder&Fetch Browse data from Pathfinder",default:\K!1&true&s&xpuiJs&1.1.88.595&1.2.24.756'
'enableCanvasContextMenuToggle&Canvas context menu toggle",default:\K!1&true&s&xpuiJs&1.2.96.200'
'enableCanvasNpv&short, looping visuals on tracks.",default:..\.\KCONTROL&CANVAS_PLAY_LOOP&s&xpuiJs&1.2.33.1039&1.2.62.580'
'enableCarouselsOnHome&Use carousels on Home",default:\K!1&true&s&xpuiJs&1.1.93.896&1.2.25.1011'
'enableCenteredLayout&Enable centered layout",default:\K!.(?=})&true&s&xpuiJs&1.2.39.578&1.2.50.335'
'enableChapteredMusicExperience&client support for the chaptered music content experience",default:\K!1&true&s&xpuiJs&1.2.96.200'
'enableClearAllDownloads&option in settings to clear all downloads",default:\K!1&true&s&xpuiJs&1.1.92.644&1.1.98.691'
'enableCommentThreadsReactionsForEpisodes&users to react and reply to comments.",default:\K!1&true&s&xpuiJs&1.2.71.421&1.2.81.264'
'enableConcertCampaignPage&concert campaign page",default:\K!1&true&s&xpuiJs&1.2.78.397'
'enableConcertEntityPathfinderDWP&Use pathfinder for the concert entity page on DWP",default:\K!1&true&s&xpuiJs&1.2.25.1009&1.2.33.1039'
'enableConcertGenres&concert genres on the live events feed",default:\K!1&true&s&xpuiJs&1.2.46.462&1.2.58.498'
'enableConcertsCarouselForThisIsPlaylist&Concerts Carousel on This is Playlist",default:\K!1&true&s&xpuiJs&1.2.26.1180&1.2.63.394'
'enableConcertsForThisIsPlaylist&Tour Card on This is Playlist",default:\K!1&true&s&xpuiJs&1.2.11.911&1.2.62.580'
'enableConcertsInSearch&concerts in search",default:\K!1&true&s&xpuiJs&1.2.33.1039&1.2.78.418'
'enableConcertsInterested&Save . Retrieve feature for concerts",default:\K!1&true&s&xpuiJs&1.2.7.1264&1.2.62.580'
'enableConcertsNearYou&Concerts Near You Playlist",default:\K!1&true&s&xpuiJs&1.2.11.911'
'enableConcertsNearYouFeedPromoDWP&Show the promo card for Concerts Near You playlist on Concert Feed",default:\K!1&true&s&xpuiJs&1.2.23.1114&1.2.57.463'
'enableConcertsNotInterested&ser to set not interested on concerts",default:\K!1&true&s&xpuiJs&1.2.53.437'
'enableConcertsTicketPrice&Display ticket price on Event page",default:\K!1&true&s&xpuiJs&1.2.15.826&1.2.62.580'
'enableContextMenuLayoutV2&the Context Menu 2.0 layout",default:\K!1&true&s&xpuiJs&1.2.96.200'
'enableContextMenuShortcuts&inline keyboard shortcuts for common context menu items",default:\K!1&true&s&xpuiJs&1.2.69.448'
'enableContextualTrackBans&ability to ban.hide tracks from eligible contexts",default:\K!1&true&s&xpuiJs&1.2.52.442&1.2.83.461'
'enableCreateButton&create button either in the global navbar or in YLX",values:.{1,3},default:.{1,3}.\KNONE&YOUR_LIBRARY&s&xpuiJs&1.2.57.460&1.2.81.264'
'enableDiscographyShelf&condensed disography shelf on artist pages",default:\K!.(?=})&true&s&xpuiJs&1.1.79.763&1.2.50.335'
'enableDynamicNormalizer&dynamic normalizer.compressor",default:\K!1&true&s&xpuiJs&1.2.14.1141&1.2.60.564'
'enableEightShortcuts&Increase max number of shortcuts on home to 8",default:\K!1&true&s&xpuiJs&1.2.26.1180&1.2.45.454'
'enableEncoreCards&all cards throughout app to be Encore Cards",default:\K!1&true&s&xpuiJs&1.2.21.1104&1.2.33.1042'
'enableEncorePlaybackButtons&Use Encore components in playback control components",default:\K!1&true&s&xpuiJs&1.2.20.1210&1.2.43.420'
'enableEncoreSpotifyMixNonLatin&Spotify Mix non-Latin font support .Arabic, Cyrillic, Greek, Hebrew, Thai.",default:\K!.(?=})&true&s&xpuiJs&1.2.98.250'
'enableEntityHeaderNew&Enable the new entity header design",default:\K!.(?=})&true&s&xpuiJs&1.2.95.200'
'enableEqualizer&audio equalizer for Desktop and Web Player",default:\K!1&true&s&xpuiJs&1.1.88.595'
'enableExcludeTrackFromTasteProfile&option to exclude track from taste profile via context menu",default:\K!1&true&s&xpuiJs&1.2.73.451'
'enableExtraTracklistColumns&extra tracklist columns",default:\K!1&true&s&xpuiJs&1.2.44.405&1.2.71.421'
'enableFC24EasterEgg&EA FC 24 easter egg",default:\K!1&true&s&xpuiJs&1.2.20.1210&1.2.53.440'
'enableForgetDevice&option to Forget Devices",default:\K!1&true&s&xpuiJs&1.2.0.1155&1.2.5.1006'
'enableFullscreenMode&Enable fullscreen mode",default:\K!1&true&s&xpuiJs&1.2.31.1205'
'enableGlobalCreateButton&plus button for creating different types of playlists from global nav bar",default:\K!1&true&s&xpuiJs&1.2.53.437&1.2.56.502'
'enableGlobalNavBar&Show global nav bar with home button, search input and user avatar",default:..\.\KCONTROL&HOME_NEXT_TO_SEARCH&s&xpuiJs&1.2.30.1135&1.2.45.454'
'enableHideListeningActivityFromProfile&hiding another user.s listening activity from their profile menu",default:\K!1&true&s&xpuiJs&1.2.97.250'
'enableHomeCarousels&carousels on home",default:\K!1&true&s&xpuiJs&1.2.44.405&1.2.62.580'
'enableHomePin&pinning of home shelves",default:\K!1&true&s&xpuiJs&1.2.45.451'
'enableIgnoreInRecommendations&Ignore In Recommendations for desktop and web",default:\K!.(?=})&true&s&xpuiJs&1.1.87.612&1.2.50.335'
'enableInlineCuration&new inline playlist curation tools",default:\K!1&true&s&xpuiJs&1.1.70.610&1.2.25.1011'
'enableLikedSongsAsPlaylist&Liked Songs on list platform with playlist uri",default:\K!1&true&s&xpuiJs&1.2.75.499&1.2.93.667'
'enableLikedSongsFilterTags&Show filter tags on the Liked Songs entity view",default:\K!1&true&s&xpuiJs&1.2.32.985'
#'enableLikedSongsListPlatform&Liked Songs on list platform",default:\K!1&true&s&xpuiJs&1.2.41.434'
'enableListPrivateByDefaultSetting&List Private By Default setting in Desktop Social Settings",default:\K!1&true&s&xpuiJs&1.2.78.397'
'enableLiveEventsListView&list view for Live Events feed",default:\K!1&true&s&xpuiJs&1.2.14.1141&1.2.18.999'
'enableLocalConcertsInSearch&local concert recommendations in search",default:\K!1&true&s&xpuiJs&1.2.36.955&1.2.78.418'
'enableLyricsCheck&clients will check whether tracks have lyrics available",default:\K!1&true&s&xpuiJs&1.1.70.610&1.1.93.896'
'enableLyricsMatch&Lyrics match labels in search results",default:\K!.(?=})&true&s&xpuiJs&1.1.87.612&1.2.50.335'
'enableLyricsNew&new fullscreen lyrics page",default:\K!1&true&s&xpuiJs&1.1.84.716&1.1.86.857'
'enableLyricsScrollToCurrentLineButton&scroll to current line button in lyrics",default:\K!1&true&s&xpuiJs&1.2.65.255&1.2.77.144'
'enableMadeForYouEntryPoint&Show "Made For You" entry point in the left sidebar.,default:\K!1&true&s&xpuiJs&1.1.70.610&1.1.95.893'
'enableMarkBookAsFinished&ability to mark a book as finished",default:\K!1&true&s&xpuiJs&1.2.44.405'
'enableMerchHubWrappedTakeover&Route merchhub url to the new genre page for the wrapped takeover",default:\K!1&true&s&xpuiJs&1.2.22.975&1.2.39.578'
'enableMoreLikeThisPlaylist&More Like This playlist for playlists the user cannot edit",default:\K!1&true&s&xpuiJs&1.2.32.985&1.2.73.474'
'enableMusicVideos&available for the current user. Override to true for supported products and markets.",default:\K!1&true&s&xpuiJs&1.2.96.200'
'enableNearbyJams&support for Nearby Jams feature in the Device Picker",default:\K!1&true&s&xpuiJs&1.2.52.442&1.2.97.270'
'enableNewArtistEventsPage&Display the new Artist events page",default:\K!1&true&s&xpuiJs&1.2.18.997&1.2.32.997'
'enableNewConcertFeed&Enables new concert feed experience",default:\K!1&true&s&xpuiJs&1.2.37.701&1.2.50.335'
'enableNewConcertLocationExperience&new concert location experience modal selector.",default:\K!1&true&s&xpuiJs&1.2.34.783&1.2.42.290'
'enableNewEntityHeaders&New Entity Headers",default:\K!1&true&s&xpuiJs&1.2.15.826&1.2.28.0'
'enableNewEpisodes&new episodes view",default:\K!1&true&s&xpuiJs&1.1.84.716&1.2.62.580'
#'enableNewOverlayScrollbars&new overlay scrollbars",default:\K!1&true&s&xpuiJs&1.2.58.492'
'enableNewPodcastTranscripts&showing podcast transcripts on desktop and web player",default:\K!1&true&s&xpuiJs&1.1.84.716&1.2.25.1011'
'enableNewRecentsPage&the new Recents page",default:\K!1&true&s&xpuiJs&1.2.76.256'
'enableNextBestEpisode&next best episode block on the show page",default:\K!1&true&s&xpuiJs&1.1.99.871&1.2.28.581'
'enableNotificationCenter&notification center for desktop . web",default:\K!1&true&s&xpuiJs&1.2.75.499'
'enableNowPlayingBarVideo&showing video in Now Playing Bar when all other video elements are closed",default:\K!1&true&s&xpuiJs&1.2.22.975'
'enableNowPlayingBarVideoSwitch&a switch to toggle video in the Now Playing Bar",default:\K!1&true&s&xpuiJs&1.2.28.581&1.2.29.605'
'enableNPVCredits enableNPVCreditsWithLinkability&credits in the right sidebar",default:\K!.(?=})&true&gs&xpuiJs&1.2.26.1180&1.2.50.335'
'enableNPVideosV2&NPV 2.0 Video experience for testing",default:\K!1&true&s&xpuiJs&1.2.19.937&1.2.96.518'
'enableOtfn&On-The-Fly-Normalization",default:\K!1&true&s&xpuiJs&1.2.31.1205'
'enableOverlaySidebarAnimations&Enable entry and exit animations for the overlay panels .queue, device picker, buddy feed.... in the side bar",default:\K!1&true&s&xpuiJs&1.2.38.720&1.2.45.454'
'enablePeekNpv&the Peek NPV feature",default:\K!1&true&s&xpuiJs&1.2.53.437&1.2.96.518'
'enablePiPMiniPlayer&the PiP Mini Player",default:\K!.(?=})&true&s&xpuiJs&1.2.32.985'
'enablePiPMiniPlayerQueue&PiP Queue behind miniplayer settings",default:\K!1&true&s&xpuiJs&1.2.67.553'
'enablePiPMiniPlayerSettings&PiP settings",default:\K!1&true&s&xpuiJs&1.2.65.255'
'enablePiPMiniPlayerVideo&playback of video inside the PiP Mini Player",default:\K!.(?=})&true&s&xpuiJs&1.2.32.985'
'enablePlaybackBarAnimation&animation of the playback bar",default:\K!1&true&s&xpuiJs&1.2.34.783&1.2.82.428'
'enablePlaylistCreationFlow&new playlist creation flow in Web Player and DesktopX",default:\K!1&true&s&xpuiJs&1.1.70.610&1.1.93.896'
'enablePlaylistPermissionsProd&Playlist Permissions flows for Prod",default:\K!.(?=})&true&s&xpuiJs&1.1.75.572&1.2.50.335'
'enablePlaylistReleaseDateColumn&Enables the release date column in playlist tracklists",default:\K!.(?=})&true&s&xpuiJs&1.2.95.200'
'enablePodcastChaptersInNpv&showing podcast chapters in NPV",default:\K!.(?=})&true&s&xpuiJs&1.2.22.975&1.2.50.335'
'enablePodcastChapterPage&the podcast chapter entity page",default:\K!.(?=})&true&s&xpuiJs&1.2.85.504&1.2.93.667'
'enablePodcastDescriptionAutomaticLinkification&Linkifies anything looking like a url in a podcast description.",default:\K!1&true&s&xpuiJs&1.2.19.937'
'enablePremiumUserForMiniPlayer&premium user flag for mini player",default:\K!1&true&s&xpuiJs&1.2.32.985'
'enablePrereleaseRadar&Show a curated list of upcoming albums to a user",default:\K!1&true&s&xpuiJs&1.2.39.578&1.2.45.454'
'enableProfileVisibilityControls&profile visibility controls in the settings . profile page",default:\K!1&true&s&xpuiJs&1.2.74.462&1.2.85.519'
'enableProgressBarEpisodeChapters&pisode chapters markers in the progress bar",default:\K!1&true&s&xpuiJs&1.2.68.525&1.2.74.477'
'enableProgressBarRefactorWithChapters&refactored ProgressBar implementation with chapter support",default:\K!1&true&s&xpuiJs&1.2.74.462&1.2.82.428'
'enableQueueOnRightPanel&Enable Queue on the right panel.",default:\K!.(?=})&true&s&xpuiJs&1.2.26.1180&1.2.61.443'
'enableQueueOnRightPanelAnimations&animations for Queue on the right panel.",default:\K!.(?=})&true&s&xpuiJs&1.2.32.985&1.2.50.335'
'enableReactQueryPersistence&React Query persistence",default:\K!.(?=})&true&s&xpuiJs&1.2.30.1135'
'enableReadAlongTranscripts&read along transcripts in the NPV",default:\K!.(?=})&true&s&xpuiJs&1.2.17.832&1.2.62.580'
'enableRecentlyPlayedShortcut&Show Recently Played shortcut in home view. Also increase max number of shortcuts to 8",default:\K!1&true&s&xpuiJs&1.2.21.1104&1.2.25.1011'
'enableRecentSearchesDropdown&recent searches dropdown in GlobalNavBar",default:\K!1&true&s&xpuiJs&1.2.45.451&1.2.52.442'
'enableRelatedVideos&Related Video section in NPV",default:\K!1&true&s&xpuiJs&1.2.21.1104'
'enableResizableTracklistColumns&resizable tracklist columns",default:\K!1&true&s&xpuiJs&1.2.28.581&1.2.66.447'
'enableRightSidebarArtistEnhanced&Enable Artist about V2 section in NPV",default:\K!.(?=})&true&s&xpuiJs&1.2.16.947&1.2.50.335'
'enableRightSidebarCollapsible&right sidebar to collapse into the right margin",default:\K!1&true&s&xpuiJs&1.2.34.783&1.2.37.701'
'enableRightSidebarCredits&Show credits in the right sidebar",default:\K!1&true&s&xpuiJs&1.2.7.1264&1.2.25.1011'
'enableRightSidebarMerchFallback&Allow merch to fallback to artist level merch if track level does not exist",default:\K!1&true&s&xpuiJs&1.2.5.954&1.2.11.916'
'enableRightSidebarTransitionAnimations&Enable the slide-in.out transition on the right sidebar",default:\K!1&true&s&xpuiJs&1.2.7.1264&1.2.33.1042'
'enableSearchBox&filter playlists when trying to add songs to a playlist using the contextmenu",default:\K!1&true&s&xpuiJs&1.1.86.857&1.1.93.896'
'enableSearchSuggestions&the search suggestions dropdown",default:\K!1&true&s&xpuiJs&1.2.72.435'
'enableSearchV3&new Search experience",default:\K!1&true&s&xpuiJs&1.1.87.612&1.2.34.783'
'enableScrollDrivenAnimations&croll driven animations for cards and shelved",default:\K!1&true&s&xpuiJs&1.2.39.578'
'enableShareActionBarButton&Shows a share button in entity page action bars that opens the share dialog",default:\K!.(?=})&true&s&xpuiJs&1.2.85.504'
'enableShareDialog&the share dialog modal instead of the share submenu",default:\K!.(?=})&true&s&xpuiJs&1.2.85.504&1.2.93.667'
'enableSharingButtonOnMiniPlayer&sharing button on MiniPlayer .this also moves the ... icon close to the title.",default:\K!1&true&s&xpuiJs&1.2.39.578&1.2.43.420'
'enableShortLinks&short links for sharing",default:\K!1&true&s&xpuiJs&1.2.34.783'
'enableShowFollowsSetting&control if followers and following lists are shown on profile",default:\K!.(?=})&true&s&xpuiJs&1.2.1.958&1.2.50.335'
'enableShowRating&new UI for rating books and podcasts",default:\K!1&true&s&xpuiJs&1.2.32.985&1.2.62.580'
'enableShuffleSettings&shuffle settings section in advanced settings",default:\K!1&true&s&xpuiJs&1.2.75.499'
'enableSidebarAnimations&animations on the left and right on the sidebars and makes the right sidebar collapsible",default:\K!1&true&s&xpuiJs&1.2.34.783&1.2.37.701'
'enableSilenceTrimmer&silence trimming in podcasts",default:\K!1&true&s&xpuiJs&1.1.99.871&1.2.93.667'
'enableSkipNextTooltip&tooltip that shows a preview of the next item in queue.",values:.{1,3},default:.{1,4}\KDisabled&Expanded&s&xpuiJs&1.2.65.255&1.2.85.519'
'enableSocialConnectOnDesktop&the Social Connect API that powers group listening sessions for Desktop",values:.{1,3},default:.{1,4}\KDISABLED&ENABLED&s&xpuiJs&1.2.21.1104&1.2.45.454'
'enableSmallerLineHeight&line height 1.5 on the .body ..",default:\K!1&true&s&xpuiJs&1.2.18.997&1.2.23.1125'
'enableSmallPlaybackSpeedIncrements&playback speed range from 0.5-3.5 with every 0.1 increment",default:\K!1&true&s&xpuiJs&1.2.0.1155&1.2.14.1149'
'enableSmartShuffle&Enable Smart Shuffle",default:\K!1&true&s&xpuiJs&1.2.26.1180&1.2.96.518'
'enableStaticImage2Optimizer&static image2 optimizer to optimize image urls",default:\K!.(?=})&true&s&xpuiJs&1.2.20.1210&1.2.78.418'
'enableStrangerThingsEasterEgg&Stranger Things upside down Easter Egg",default:\K!1&true&s&xpuiJs&1.1.91.824'
'enableSubtitlesAutogeneratedLabel&label in the subtitle picker.,default:\K!.(?=})&true&s&xpuiJs&1.1.70.610&1.2.50.335'
'enableSyncingSearchHistoryToBackend&syncing search history to the backend",default:\K!1&true&s&xpuiJs&1.2.75.499&1.2.85.519'
'enableSystemAudioOutputsInDevicePicker&selecting currently connected system audio outputs, such as BT and wired devices, in the device picker",default:\K!1&true&s&xpuiJs&1.2.97.250'
'enableTiltable3DArtwork&tiltable 3D parallax effect on artwork .Cinema Mode and Cover Art Modal.",default:\K!1&true&s&xpuiJs&1.2.76.256'
'enableTogglePlaylistColumns&ability to toggle playlist column visibility",default:\K!1&true&s&xpuiJs&1.2.17.832&1.2.66.447'
'enableTracklistColumnsSorting&column reordering functionality in tracklists",default:\K!1&true&s&xpuiJs&1.2.69.448&1.2.96.518'
'enableTracklistColumnsV2&identity-keyed tracklist columns, layout, and reordering",default:\K!1&true&s&xpuiJs&1.2.97.250'
'enableTranscriptTextSelection&text selection and copy in episode transcripts on desktop",default:\K!.(?=})&true&s&xpuiJs&1.2.95.200'
'enableUserCommentsForEpisodes&user comments for podcast episodes",default:\K!1&true&s&xpuiJs&1.2.49.439'
'enableUserCreatedArtwork&user created artworks for playlists",default:\K!1&true&s&xpuiJs&1.2.34.783&1.2.40.599'
'enableUserProfileEdit&editing of user.s own profile in Web Player and DesktopX",default:\K!1&true&s&xpuiJs&1.1.87.612&1.2.25.1011'
'enableUserVideoSettings&Show video preference settings for users to control video playback types",default:\K!1&true&s&xpuiJs&1.2.86.502&1.2.95.453'
'enableVenuePages&Enables venus pages",default:\K!1&true&s&xpuiJs&1.2.37.701&1.2.74.477'
'enableVideoLabelForSearchResults&video label for search results",default:\K!1&true&s&xpuiJs&1.2.23.1114&1.2.29.605'
'enableVideoPip&desktop picture-in-picture surface using betamax SDK.",default:\K!1&true&s&xpuiJs&1.2.13.656'
'enableVideoShelfPreviews&video previews on hover in video shelf cards",default:\K!1&true&s&xpuiJs&1.2.96.200'
'enableViewMode&list . compact mode in entity pages",default:\K!1&true&s&xpuiJs&1.2.24.754'
'enableWatchFeed&Enable Watch Feed feature",default:\K!1&true&s&xpuiJs&1.2.56.497'
'enableWatchFeedEntityPages&Watch Feed feature on entity pages",default:\K!1&true&s&xpuiJs&1.2.56.497'
'enableWhatsNewFeed&what.s new feed panel",default:\K!1&true&s&xpuiJs&1.2.12.902&1.2.16.947'
'enableWhatsNewFeedMainView&Whats new feed in the main view",default:\K!1&true&s&xpuiJs&1.2.17.832&1.2.45.454'
'enableWrapped2025ListenCount&displaying listen counts for tracks in Wrapped 2025 Your Top Songs playlists",default:\K!1&true&s&xpuiJs&1.2.80.349'
'enableYLXEnhancements&Your Library X Enhancements",default:\K!1&true&s&xpuiJs&1.2.18.997&1.2.50.335'
'enableYlxMultiSelect&multi selection in Your Library",default:\K!1&true&s&xpuiJs&1.2.72.435'
'enableYLXPrereleaseAlbums&album pre-releases in YLX",default:\K!1&true&s&xpuiJs&1.2.32.985'
'enableYLXPrereleaseAudiobooks&audiobook pre-releases in YLX",default:\K!1&true&s&xpuiJs&1.2.32.985&1.2.47.366'
'enableYLXPrereleases&album pre-releases in YLX",default:\K!1&true&s&xpuiJs&1.2.31.1205&1.2.31.1205'
'enableYlxReverseSorting&Enable reverse sort direction in Your Library",default:\K!1&true&s&xpuiJs&1.2.60.564&1.2.94.583'
'enableYLXTypeaheadSearch&jump to the first matching item",default:\K!1&true&s&xpuiJs&1.2.13.656'
'enableZoomSettingsUIDesktop&zoom settings from the settings page on Desktop",default:\K!1&true&s&xpuiJs&1.2.17.832&1.2.53.437'
'isVideoQualityEnabled&video quality settings and the in-player quality picker",default:\K!1&true&s&xpuiJs&1.2.84.194'
'saveButtonAlwaysVisible&Display save button always in whats new feed",default:\K!1&true&s&xpuiJs&1.2.20.1210&1.2.28.0'
'shareButtonPositioning&Share button positioning in NPV",values:.{1,3},default:.{1,4}NPV_\K(HIDDEN|VISIBLE_ON_HOVER)&ALWAYS_VISIBLE&s&xpuiJs&1.2.39.578&1.2.50.335'
'showWrappedBanner&Show Wrapped banner on wrapped genre page",default:\K!1&true&s&xpuiJs&1.1.87.612&1.2.53.440'
)
premiumExpEx=(
'addYourDJToLibraryOnPlayback&Add Your DJ to library on playback",default:\K!1&true&s&xpuiJs&1.2.6.861&1.2.50.335'
'enableJamBroadcasting&Jam broadcasting and scanning",default:\K!1&true&s&xpuiJs&1.2.45.451&1.2.59.518'
'enableJamNearbyJoining&Jam Nearby Joining Connect devices in Connect Picker",default:\K!1&true&s&xpuiJs&1.2.60.564'
'enableOfflineAlbumsListPlatform&offline albums loaded over List Platform",default::\K!1&true&s&xpuiJs&1.2.48.404'
'enableYourDJ&the .Your DJ. feature.,default:\K!1&true&s&xpuiJs&1.2.6.861'
'enableYourSoundCapsuleModal&showing a modal on desktop to users who have clicked on a Your Sound Capsule share link",default:\K!1&true&s&xpuiJs&1.2.38.720'
)

trap cleanup_temp_dirs EXIT
trap 'exit 130' HUP INT TERM

run_prepare
run_uninstall_check
run_interactive_check
run_install_check
run_cache_check
run_core_start
run_patches
run_finish

printf "\xE2\x9C\x94\x20\x46\x69\x6E\x69\x73\x68\x65\x64\n\n"
exit 0
