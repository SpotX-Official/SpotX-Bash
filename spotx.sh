#!/usr/bin/env bash

buildVer="1.2.17.834.g26ee1129"

case $(uname | tr '[:upper:]' '[:lower:]') in
  darwin*) platformType='macOS' ;;
        *) platformType='Linux' ;;
esac

if [[ "${platformType}" == "macOS" ]]; then
  showHelp () {
    echo -e \
"Options:
-B           : block Spotify auto-updates (--blockupdates)
-c           : clear Spotify app cache (--clearcache)
-d           : enable developer mode (--devmode)
-e           : exclude all experimental features (--noexp)
-f           : force SpotX-Bash to run (--force)
-h           : hide non-music on home screen (--hide)
--help       : print this help message
-i           : enable interactive mode (--interactive)
-I           : install latest supported client (--installclient)
-o           : use old home screen UI (--oldui)
-p           : paid premium-tier subscriber (--premium)
-P [path]    : set path to Spotify
-S           : skip codesigning (--skipcodesign)
--uninstall  : uninstall SpotX-Bash
-v           : print SpotX-Bash version (--version)
-V [version] : install client version
"
}
else 
  showHelp () {
    echo -e \
"Options:
-c          : clear Spotify app cache (--clearcache)
-d          : enable developer mode (--devmode)
-e          : exclude all experimental features (--noexp)
-f          : force SpotX-Bash to run (--force)
-h          : hide non-music on home screen (--hide)
--help      : print this help message
-i          : enable interactive mode (--interactive)
-o          : use old home screen UI (--oldui)
-p          : paid premium-tier subscriber (--premium)
-P [path]   : set path to Spotify
--uninstall : uninstall SpotX-Bash
-v          : print SpotX-Bash version (--version)
"
}
fi

clear='\033[0m'
green='\033[0;32m'
red='\033[0;31m'
yellow='\033[0;33m'

while getopts ':BcdefF:hIiopP:SvV:-:' flag; do
  case "${flag}" in
    -)
      case "${OPTARG}" in
        blockupdates) blockUpdates='true' ;;
        clearcache) clearCache='true' ;;
        devmode) devMode='true' ;;
        force) forceSpotx='true' ;;
        help) showHelp; exit 0 ;;
        hide) hideNonMusic='true' ;;
        installclient) installClient='true' ;;
        interactive) interactiveMode='true' ;;
        logo) logoVar='true' ;;
        noexp) excludeExp='true' ;;
        oldui) oldUi='true' ;;
        premium) paidPremium='true' ;;
        skipcodesign) skipCodesign='true' ;;
        uninstall) uninstallSpotx='true' ;;
        version) verPrint='true' ;;
        *) echo -e "${red}Error:${clear} '--""${OPTARG}""' not supported\n\n$(showHelp)\n" >&2; exit 1 ;;
      esac ;;
    B) blockUpdates='true' ;;
    c) clearCache='true' ;;
    d) devMode='true' ;;
    e) excludeExp='true' ;;
    f) forceSpotx='true' ;;
    F) forceVer="${OPTARG}"; clientVer="${forceVer}" ;;
    h) hideNonMusic='true' ;;
    i) interactiveMode='true' ;;
    I) installClient='true' ;;
    o) oldUi='true' ;;
    p) paidPremium='true' ;;
    P) p="${OPTARG}"; installPath="${p}" ;;
    S) skipCodesign='true' ;;
    v) verPrint='true' ;;
    V)
      if [[ "${OPTARG}" =~ ^[1]\.[1,2]\.[0-9][0-9]?\.[0-9][0-9][0-9].*$ ]]; then
        V="${OPTARG}"; versionVar="${V}"; installClient='true'
      else
       echo -e "${red}Error:${clear} Invalid or unsupported version\n" >&2; exit 1
      fi ;;
    \?) echo -e "${red}Error:${clear} '-""${OPTARG}""' not supported\n\n$(showHelp)\n" >&2; exit 1 ;;
    :) echo -e "${red}Error:${clear} '-""${OPTARG}""' requires additional argument\n\n$(showHelp)\n" >&2; exit 1 ;;
  esac
done

gVer="$(echo "==gCk1mLF1ERBVkUvcXYy9SMidjZ0QzMkRTOwMWZlVTMmRTY2EmYlRGOmNGMzgDOl9yMylmZ0Vmav02bj5iY1hGdpdmL0NXan9yL6MHc0RHa" | rev | base64 --decode)"
sxbLive="$(curl -q -sL "${gVer}" | perl -ne '/g\>\h(.*)/ && print "$1"' 2>/dev/null)"
sxbVer="$(echo ${buildVer} | perl -ne '/(.*)\./ && print "$1"')"
verCk="$(echo "uxFXoNXYihHdvB3cvQ2ZuMXagAEIlxmYhxWahZXYgMXag0nchVGbjtHJi0XZ2lGTih3c7RiI95WZlJ3Z7RCIu9WazJXZW5GXc5CZlRXYkRXdvBycpBCazFmQtgFdvB3UgY2bg42bpNnclZHIzlGaUBSfyFWZsN2ekozZulmbyF2V9d3bsxWZ5tHJ" | rev | base64 --decode)"
verCk2="$(eval echo "${verCk}")"
ver () { echo "$@" | awk -F. '{ printf("%d%03d%04d%05d\n", $1,$2,$3,$4); }'; }
verCk3 () { (($(ver "${sxbVer}") > $(ver "1.1.0.0") && $(ver "${sxbVer}") < $(ver "${sxbLive}"))) && echo -e "${verCk2}"; }

[[ "${verPrint}" ]] && { echo -e "SpotX-Bash version ${sxbVer}\n"; verCk3; exit 0; }

command -v perl >/dev/null || { echo -e "\n${red}Error:${clear} perl command not found.\nInstall perl on your system then try again.\n" >&2; exit 1; }
command -v unzip >/dev/null || { echo -e "\n${red}Error:${clear} unzip command not found.\nInstall unzip on your system then try again.\n" >&2; exit 1; }
command -v zip >/dev/null || { echo -e "\n${red}Error:${clear} zip command not found.\nInstall zip on your system then try again.\n" >&2; exit 1; }

echo
echo "████╗███╗  ███╗ █████╗█╗  █╗  ███╗  ██╗ ████╗█╗ █╗"
echo "█╔══╝█╔═█╗█╔══█╗╚═█╔═╝╚█╗█╔╝  █╔═█╗█╔═█╗█╔══╝█║ █║"
echo "████╗███╔╝█║  █║  █║   ╚█╔╝██╗███╔╝████║████╗████║"
echo "╚══█║█╔═╝ █║  █║  █║   █╔█╗╚═╝█╔═█╗█╔═█║╚══█║█╔═█║"
echo "████║█║   ╚███╔╝  █║  █╔╝ █╗  ███╔╝█║ █║████║█║ █║"
echo "╚═══╝╚╝    ╚══╝   ╚╝  ╚╝  ╚╝  ╚══╝ ╚╝ ╚╝╚═══╝╚╝ ╚╝"
echo 

[[ "${logoVar}" ]] && exit 0

if [[ "${platformType}" == "macOS" ]]; then
  (("${OSTYPE:6:2}" < 15)) && { echo -e "\n${red}Error:${clear} OS X 10.11+ required\n" >&2; exit 1; }
  [[ -z "${skipCodesign+x}" ]] && { command -v codesign >/dev/null || { echo -e "\n${red}Error:${clear} codesign command not found.\nInstall Xcode Command Line Tools then try again.\n\nEnter the following command in Terminal to install:\n${yellow}xcode-select --install${clear}\n" >&2; exit 1; } }
  [[ -z ${versionVar+x} ]] && versionVar="${buildVer}"
  [[ $(sysctl -n machdep.cpu.brand_string) =~ "Apple" ]] && archVar="arm64" || archVar="x86_64"
  grab1="$(echo "==wSRhUZwUTejxGeHNGdGdUZslTaiBnRXJmdJJjYzpkMMVjWXFWYKVkV21kajBnWHRGbwJDT0ljMZVXSXR2bShVYulTeMZTTINGMShUY" | rev | base64 -D | base64 -D)"
  grab2="$(curl -q -sL "${grab1}" | perl -ne '/(ht.{6}u.{33}-'"${archVar}"'.{19}-'"${versionVar}"'.{1,20}bz)/ && print "$1"')"
  fileVar="$(echo "${grab2}" | grep -o "sp.*z")"
  [[ "${installClient}" ]] && downloadVer="$(echo "${fileVar}" | perl -ne '/te-(.*)\..*\./ && print "$1"')"
  [[ "${downloadVer}" ]] && (($(ver "${downloadVer}") < $(ver "1.1.59.710"))) && { echo -e "${red}Error:${clear} ${downloadVer} not supported by SpotX-Bash\n" >&2; exit 1; }
  if [[ -z "${installPath+x}" ]]; then
    appPath="/Applications/Spotify.app"
    [[ -d "${HOME}${appPath}" ]] && installPath="${HOME}/Applications"
    [[ -d "${appPath}" ]] && installPath="/Applications"
    [[ ! -d "${HOME}${appPath}" && ! -d "${appPath}" ]] && { interactiveMode='true'; notInstalled='true'; installPath="/Applications"; echo -e "\n${yellow}Warning:${clear} Spotify not found. Starting interactive mode...\n" >&2; }
  else
    [[ -d "${installPath}/Spotify.app" ]] || { echo -e "${red}Error:${clear} Spotify.app not found in path set by '-P'.\nConfirm directory and try again.\n" >&2; exit 1; }
  fi
  appPath="${installPath}/Spotify.app"
  appBinary="${appPath}/Contents/MacOS/Spotify"
  appBak="${appPath}/Contents/MacOS/Spotify.bak"
  cachePath="${HOME}/Library/Caches/com.spotify.client"
  xpuiPath="${installPath}/Spotify.app/Contents/Resources/Apps"
  [[ "${skipCodesign}" ]] && echo -e "${yellow}Warning:${clear} Codesigning has been skipped.\n" >&2
fi

if [[ "${platformType}" == "Linux" ]]; then
  if [[ -z "${installPath+x}" ]]; then
    echo -e "Searching for Spotify directory...\n"
    installPath=$(timeout 20 find / -type f -path "*/spotify*Apps/*" -name "xpui.spa" -size -10M -size +3M -print -quit 2>/dev/null | rev | cut -d/ -f3- | rev)
    [[ -d "${installPath}" ]] && echo -e "Found Spotify Directory: ${installPath}\n" || { echo -e "${red}Error:${clear} Spotify directory not found.\nSet directory path with '-P' flag.\n" >&2; exit 1; }
  else
    [[ -f "${installPath}/Apps/xpui.spa" ]] && echo -e "Using Spotify Directory: ${installPath}\n" || { echo -e "${red}Error:${clear} Spotify not found in path set by '-P'.\nConfirm directory and try again.\n" >&2; exit 1; }
  fi
  appBinary="${installPath}/spotify"
  appBak="${installPath}/spotify.bak"
  cachePath=$(timeout 10 find / -type d -path "*cache/spotify*" -name "spotify" -print -quit 2>/dev/null)
  xpuiPath="${installPath}/Apps"
fi

xpuiDir="${xpuiPath}/xpui"
xpuiBak="${xpuiPath}/xpui.bak"
xpuiSpa="${xpuiPath}/xpui.spa"
xpuiJs="${xpuiDir}/xpui.js"
xpuiCss="${xpuiDir}/xpui.css"
homeHptoJs="${xpuiDir}/home-hpto.js"
#homeV2Js="${xpuiDir}/home-v2.js"
vendorXpuiJs="${xpuiDir}/vendor~xpui.js"
xpuiDesktopModalsJs="${xpuiDir}/xpui-desktop-modals.js"

[[ "${platformType}" == "macOS" && -z "${installClient+x}" && -z "${notInstalled+x}" && -z "${forceVer+x}" ]] && { [[ -f "${appPath}/Contents/Info.plist" ]] && clientVer=$(perl -ne 'if($v=/ShortVersion/..undef){print if($v>1 && $v<=2)}' "${appPath}/Contents/Info.plist" 2>/dev/null | perl -ne '/\>(.*)\./ && print "$1"') || versionFailed='true'; }
[[ "${platformType}" == "Linux" && -z "${forceVer+x}" ]] && { "${appBinary}" --version >/dev/null 2>/dev/null && clientVer=$("${appBinary}" --version | cut -d " " -f3- | rev | cut -d. -f2- | rev) || versionFailed='true'; }

perlVar="perl -pi -w -e"

adAds='s#/a\Kd(?=s/v1)|/a\Kd(?=s/v2/t)|/a\Kd(?=s/v2/se)#b#gs'
adAudioAds='s/(case .:|async enable\(.\)\{)(this.enabled=.+?\(.{1,3},"audio"\),|return this.enabled=...+?\(.{1,3},"audio"\))((;case 4:)?this.subscription=this.audioApi).+?this.onAdMessage\)/$1$3.cosmosConnector.increaseStreamTime(-100000000000)/'
adBillboard='s|.(\?\[.{1,6}[a-zA-Z].leaderboard,)|false$1|'
adEmptyBlock='s|adsEnabled:!0|adsEnabled:!1|'
adEsper='s|(this._product_state=(.))|$1,$2.putOverridesValues({pairs:{ads:'\''0'\'',catalogue:'\''premium'\'',product:'\''premium'\'',type:'\''premium'\''}})|'
adLogic='s|\x00\K\x61(?=\x64\x2D\x6C\x6F\x67\x69\x63\x2F\x73)|\x00|'
adSponsors='s|allSponsorships||'
adSlot='s|\x00\K\x73(?=\x6C\x6F\x74\x73\x00)|\x00|'
adUpgradeButton='s/(return|.=.=>)"free"===(.+?)(return|.=.=>)"premium"===/$1"premium"===$2$3"free"===/g'
enableInAppMessaging='s|Enables quicksilver in-app messaging modal",default:\K!.(?=})|false|s'
enableDesktopMusicLeavebehinds='s|Enable music leavebehinds on eligible playlists for desktop",default:\K!.(?=})|false|s'

disableYLXSidebar='s|Enable Your Library X view of the left sidebar",default:\K!.(?=})|false|s'
disableRightSidebar='s|Enable the view on the right sidebar",default:\K!.(?=})|false|s'
enableNavAltExperiment='s|Enable the new home structure and navigation",values:.,default:\K..DISABLED|true|'
enableNavAltExperiment2='s|Enable the new home structure and navigation",values:.,default:.\K.DISABLED|.ENABLED_CENTER|'
enableYLXSidebar='s|Enable Your Library X view of the left sidebar",default:\K!1|true|s'
enablePanelSizeCoordination='s|Enable Panel Size Coordination between the left sidebar, the main view and the right sidebar",default:\K!1|true|s'
enableRightSidebar='s|Enable the view on the right sidebar",default:\K!1|true|s'
enableRightSidebarArtistEnhanced='s|Enable Artist about V2 section in NPV",default:\K!1|true|s'
enableRightSidebarColors='s|Extract background color based on artwork image",default:\K!1|true|s'
enableRightSidebarCredits='s|Show credits in the right sidebar",default:\K!1|true|s'
enableRightSidebarLyrics='s|Show lyrics in the right sidebar",default:\K!1|true|s'
enableRightSidebarMerchFallback='s|Allow merch to fallback to artist level merch if track level does not exist",default:\K!1|true|s'
enableRightSidebarTransitionAnimations='s|Enable the slide-in.out transition on the right sidebar",default:\K!1|true|s'

hideDLQual='s/(\(.,..jsxs\)\(.{1,3}|(.\(\).|..)createElement\(.{1,4}),\{(filterMatchQuery|filter:.,title|(variant:"viola",semanticColor:"textSubdued"|..:"span",variant:.{3,6}mesto,color:.{3,6}),htmlFor:"desktop.settings.downloadQuality.+?).{1,6}get\("desktop.settings.downloadQuality.title.+?(children:.{1,2}\(.,.\).+?,|\(.,.\){3,4},|,.\)}},.\(.,.\)\),)//'
hideDLIcon=' .BKsbV2Xl786X9a09XROH {display:none}'
hideDLMenu=' button.wC9sIed7pfp47wZbmU6m.pzkhLqffqF_4hucrVVQA {display:none}'
hideVeryHigh=' #desktop\.settings\.streamingQuality>option:nth-child(5) {display:none}'

hidePodcasts='s|withQueryParameters\(.\)\{return this.queryParameters=.,this}|withQueryParameters(e){return this.queryParameters=(e.types?{...e, types: e.types.split(",").filter(_ => !["episode","show"].includes(_)).join(",")}:e),this}|'
hidePodcasts2='s#(!Array.isArray\(.\)\|\|.===..length\)return null;)#$1 for (let i=0; i<(e.children?e.children.length:e.length); i++) {const key=(e.children?.[i]||e[i])?.key; if(!key||key.match(/(episode|show)/)||(e.title||t)?.match(/podcasts/i)) return null;};#'

logV3='s|sp://logging/v3/\w+||g'
logSentry='s|this\.getStackTop\(\)\.client=e|return;$&|'

connectOld1='s| connect-device-list-item--disabled||' # 1.1.70.610+
connectOld2='s|connect-picker.unavailable-to-control|spotify-connect|' # 1.1.70.610+
connectOld3='s|(className:.,disabled:)(..)|$1false|' # 1.1.70.610+
connectNew='s/return (..isDisabled)(\?(..createElement|\(.{1,10}\))\(..,)/return false$2/' # 1.1.91.824+
enableImprovedDevicePickerUI1='s|Enable showing a new and improved device picker UI",default:\K!.(?=})|true|' # 1.1.90.855 - 1.1.95.893
#enableImprovedDevicePickerUI2='s|Enable showing a new and improved device picker UI",default:\K!0|false|' # 1.1.96.783 - 1.1.97.962

betamaxFilterNegativeDuration='s|for duration that is negative",default:\K!.(?=})|false|s'
enableDsa='s|Enable showing DSA .Digital Services Act. context menu and modal for ads",default:\K!.(?=})|false|s'
enableConnectEsperantoState='s|Enable retrieving connect state from Esperanto instead of Cosmos",default:\K!.(?=})|false|s'
enableEsperantoMigration='s|Enable esperanto Migration for Ad Formats",default:\K!.(?=})|false|s'
enableHptoLocationRefactor='s|Enable new permanent location for HPTO iframe to HptoHtml.js",default:\K!.(?=})|false|s'
enableUserFraudCanvas='s|Enable user fraud Canvas Fingerprinting",default:\K!.(?=})|false|s'
enableUserFraudCspViolation='s|description:"Enable CSP violation detection",default:\K!.(?=})|false|s'
enableUserFraudSignals='s|Enable user fraud signals",default:\K!.(?=})|false|s'
enableUserFraudVerification='s|Enable user fraud verification",default:\K!.(?=})|false|s'
enableUserFraudVerificationRequest='s|Enable the IAV component make api requests",default:\K!.(?=})|false|s'
hptoEnabled='s|hptoEnabled:!\K0|1|s'
hptoShown='s|isHptoShown:!\K0|1|gs'

echo -e "Latest supported version: ${sxbVer}"
if [[ "${notInstalled}" || "${versionFailed}" ]]; then 
  echo -e "Detected Spotify version: ${red}N/A${clear}\n"
elif [[ "${installClient}" ]] && (($(ver "${downloadVer}") <= $(ver "${sxbVer}") && $(ver "${downloadVer}") > $(ver "0"))); then
  echo -e "Requested Spotify version: ${green}${downloadVer}${clear}\n"
elif [[ "${installClient}" ]] && (($(ver "${downloadVer}") > $(ver "${sxbVer}"))); then
  echo -e "Requested Spotify version: ${red}${downloadVer}${clear}\n"
elif (($(ver "${clientVer}") <= $(ver "${sxbVer}") && $(ver "${clientVer}") > $(ver "0"))); then
  echo -e "Detected Spotify version: ${green}${clientVer}${clear}\n"
elif (($(ver "${clientVer}") > $(ver "${sxbVer}"))); then
  echo -e "Detected Spotify version: ${red}${clientVer}${clear}\n"
fi

verCk3
command pgrep [sS]potify 2>/dev/null | xargs kill -9 2>/dev/null

if [[ "${uninstallSpotx}" ]]; then
  [[ ! -f "${xpuiBak}" ]] && { echo -e "${red}Error:${clear} No backup found, exiting...\n" >&2; exit 1; }
  rm "${xpuiSpa}" 2>/dev/null
  mv "${xpuiBak}" "${xpuiSpa}"
  rm "${appBinary}" 2>/dev/null
  mv "${appBak}" "${appBinary}"
  printf "\xE2\x9C\x94\x20\x46\x69\x6E\x69\x73\x68\x65\x64\x20\x75\x6E\x69\x6E\x73\x74\x61\x6C\x6C\n"
  exit 0
fi

read_yn () {
  while : ; do
    read -rp "$*" yn
    case "$yn" in
      [Yy]* ) return 0 ;;
      [Nn]* ) return 1 ;;
          * ) echo "Please answer yes or no.";;
    esac
  done
}

if [[ "${interactiveMode}" ]]; then
  printf "\xE2\x9C\x94\x20\x53\x74\x61\x72\x74\x65\x64\x20\x69\x6E\x74\x65\x72\x61\x63\x74\x69\x76\x65\x20\x6D\x6F\x64\x65\x20\x5B\x65\x6E\x74\x65\x72\x20\x79\x2F\x6E\x5D\n"
  [[ "${platformType}" == "macOS" && -z "${installClient+x}" ]] && { read_yn "Download & install Spotify ${sxbVer}? " && installClient='true'; }
  [[ "${platformType}" == "macOS" ]] && { read_yn "Block Spotify auto-updates? " && blockUpdates='true'; }
  read_yn "Enable experimental features? " || excludeExp='true'
  read_yn "Enable new home screen UI? " || oldUi='true'
  read_yn "Hide non-music categories on home screen? " && hideNonMusic='true'
  echo
fi

if [[ "${platformType}" == "macOS" && "${installClient}" ]]; then
  curl -q -f -I -s -o /dev/null "$grab2" || { echo -e "\n${red}Error:${clear} Client download failed\n" >&2; exit 1; }
  curl -q --progress-bar -f -o "$HOME/Downloads/${fileVar}" "$grab2" || { echo -e "\n${red}Error:${clear} Client download failed\n" >&2; exit 1; }
  printf "\xE2\x9C\x94\x20\x44\x6F\x77\x6E\x6C\x6F\x61\x64\x65\x64\x20\x61\x6E\x64\x20\x69\x6E\x73\x74\x61\x6C\x6C\x69\x6E\x67\x20\x53\x70\x6F\x74\x69\x66\x79\n"
  rm -rf "${appPath}" 2>/dev/null
  mkdir "${appPath}"
  tar -xpf "$HOME/Downloads/${fileVar}" -C "${appPath}" && unset notInstalled || { echo -e "\n${red}Error:${clear} Client install failed. Exiting...\n" >&2; rm "$HOME/Downloads/${fileVar}" 2>/dev/null; exit 1; }
  printf "\xE2\x9C\x94\x20\x49\x6E\x73\x74\x61\x6C\x6C\x65\x64\x20\x69\x6E\x20'"${installPath}"'\n"
  rm "$HOME/Downloads/${fileVar}"
  clientVer="$(echo "${fileVar}" | perl -ne '/te-(.*)\..*\./ && print "$1"')"
fi

[[ "${platformType}" == "macOS" && "${notInstalled}" ]] && { echo -e "${red}Error:${clear} Spotify not found\n" >&2; exit 1; }
[[ ! -f "${xpuiSpa}" ]] && { echo -e "${red}Error:${clear} Detected a modified Spotify installation!\nReinstall Spotify then try again.\n" >&2; exit 1; }

if [[ ! -w "${xpuiPath}" ]]; then
  echo -e "${yellow}Warning:${clear} SpotX does not have write permission in Spotify directory.\nRequesting sudo permission...\n" >&2
  sudo chmod a+wr "${installPath}" && sudo chmod a+wr -R "${xpuiPath}"
  [[ ! -w "${xpuiPath}" ]] && { echo -e "\n${red}Error:${clear} SpotX was not given sudo permission. Exiting...\n" >&2; exit 1; }
fi

if [[ -f "${appBak}" || -f "${xpuiBak}" ]] && [[ "${forceSpotx}" ]]; then
  [[ -f "${appBak}" ]] && { rm "${appBinary}"; cp "${appBak}" "${appBinary}"; }
  [[ -f "${xpuiBak}" ]] && { rm "${xpuiSpa}"; cp "${xpuiBak}" "${xpuiSpa}"; }
  printf "\xE2\x9C\x94\x20\x44\x65\x74\x65\x63\x74\x65\x64\x20\x26\x20\x72\x65\x73\x74\x6F\x72\x65\x64\x20\x62\x61\x63\x6B\x75\x70\n"
elif [[ -f "${appBak}" || -f "${xpuiBak}" ]] && [[ -z "${forceSpotx+x}" ]]; then
  printf "\xE2\x9C\x94\x20\x44\x65\x74\x65\x63\x74\x65\x64\x20\x62\x61\x63\x6B\x75\x70\n"
  echo -e "${yellow}Warning:${clear} SpotX has already been installed." >&2
  echo -e "Use the '-f' flag to force SpotX to run.\n" >&2
  xpuiSkip="true"
else
  cp "${xpuiSpa}" "${xpuiBak}"
  cp "${appBinary}" "${appBak}"
  printf "\xE2\x9C\x94\x20\x43\x72\x65\x61\x74\x65\x64\x20\x62\x61\x63\x6B\x75\x70\n"
fi

if [[ "${clearCache}" ]]; then
  rm -rf "${cachePath}/Browser" 2>/dev/null
  rm -rf "${cachePath}/Data" 2>/dev/null
  rm "${cachePath}/LocalPrefs.json" 2>/dev/null
  printf "\xE2\x9C\x94\x20\x43\x6C\x65\x61\x72\x65\x64\x20\x61\x70\x70\x20\x63\x61\x63\x68\x65\n"
fi

[[ "${xpuiSkip}" ]] && { printf "\xE2\x9C\x94\x20\x46\x69\x6E\x69\x73\x68\x65\x64\n\n"; exit 1; }

unzip -qq "${xpuiSpa}" -d "${xpuiDir}"

[[ "${versionFailed}" ]] && clientVer=$(perl -ne '/clientVersion\:\"(.*)\",os\:.{1,20}\.getOSName/ && print "$1"' "${xpuiJs}" | rev | cut -d'.' -f2- | rev)
(($(ver "${clientVer}") < $(ver "1.1.59.710"))) && { echo -e "${red}Error:${clear} ${downloadVer} not supported by SpotX-Bash\n" >&2; exit 1; }

if grep -Fq "SpotX" "${xpuiJs}"; then
  echo -e "\n${red}Warning:${clear} Detected SpotX but no backup file! Reinstall Spotify. Exiting...\n" >&2
  rm "${xpuiBak}" 2>/dev/null
  rm -rf "${xpuiDir}" 2>/dev/null
  exit 1
fi

if [[ -z "${paidPremium+x}" ]]; then
  $perlVar "${adAds}" "${xpuiJs}"
  $perlVar "${adAds}" "${appBinary}"
  (($(ver "${clientVer}") < $(ver "1.1.93.896"))) && $perlVar "${adAudioAds}" "${xpuiJs}"
  $perlVar "${adBillboard}" "${xpuiJs}"
  $perlVar "${enableDesktopMusicLeavebehinds}" "${xpuiJs}"
  $perlVar "${adEmptyBlock}" "${xpuiJs}"
  (($(ver "${clientVer}") >= $(ver "1.1.93.896"))) && $perlVar "${adEsper}" "${xpuiJs}"
  $perlVar "${adLogic}" "${appBinary}"
  $perlVar "${adSponsors}" "${xpuiJs}"
  $perlVar "${adSlot}" "${appBinary}"
  (($(ver "${clientVer}") < $(ver "1.1.93.896"))) && $perlVar "${adUpgradeButton}" "${xpuiJs}"
  $perlVar "${enableInAppMessaging}" "${xpuiJs}"
  $perlVar "${betamaxFilterNegativeDuration}" "${xpuiJs}"
  $perlVar "${enableConnectEsperantoState}" "${xpuiJs}"
  $perlVar "${enableDsa}" "${xpuiJs}"
  $perlVar "${enableEsperantoMigration}" "${xpuiJs}"
  $perlVar "${enableHptoLocationRefactor}" "${xpuiJs}"
  $perlVar "${hideDLQual}" "${xpuiJs}"
  $perlVar "${hptoEnabled}" "${xpuiJs}"
  (($(ver "${clientVer}") > $(ver "1.1.84.716"))) && $perlVar "${hptoShown}" "${homeHptoJs}"
  printf '%s\n%s\n%s' "${hideDLIcon}" "${hideDLMenu}" "${hideVeryHigh}"  >> "${xpuiCss}"
  (($(ver "${clientVer}") < $(ver "1.1.91.824"))) && { $perlVar "${connectOld1}" "${xpuiJs}"; $perlVar "${connectOld2}" "${xpuiJs}"; $perlVar "${connectOld3}" "${xpuiJs}"; }
  (($(ver "${clientVer}") >= $(ver "1.1.91.824") && $(ver "${clientVer}") < $(ver "1.1.96.783"))) && { $perlVar "${enableImprovedDevicePickerUI1}" "${xpuiJs}"; $perlVar "${connectNew}" "${xpuiJs}"; }
  (($(ver "${clientVer}") > $(ver "1.1.96.783"))) && $perlVar "${connectNew}" "${xpuiJs}"
  printf "\xE2\x9C\x94\x20\x42\x6C\x6F\x63\x6B\x65\x64\x20\x61\x75\x64\x69\x6F\x2C\x20\x62\x61\x6E\x6E\x65\x72\x20\x26\x20\x76\x69\x64\x65\x6F\x20\x61\x64\x73\n"
else
  printf "\xE2\x9C\x94\x20\x44\x65\x74\x65\x63\x74\x65\x64\x20\x70\x72\x65\x6D\x69\x75\x6D\x2D\x74\x69\x65\x72\x20\x70\x6C\x61\x6E\n"
  $perlVar "${adSlot}" "${appBinary}"
  printf "\xE2\x9C\x94\x20\x42\x6C\x6F\x63\x6B\x65\x64\x20\x70\x6F\x64\x63\x61\x73\x74\x20\x61\x64\x73\n"
fi

if [[ "${devMode}" ]] && (($(ver "${clientVer}") > $(ver "1.1.99.878"))); then
  [[ "${platformType}" == "Linux" ]] && $perlVar 's|\xFF\xFF\K\xE8..(?=\x00\x00\x89.\xF6\x85)|\xB8\x03\x00|' "${appBinary}"
  [[ "${platformType}" == "macOS" && "${archVar}" == "x86_64" ]] && $perlVar 's|\x95.\xFA\xFF\xFF\K\xE8..(?=\x00\x00\x89.\xF6)|\xB8\x03\x00|' "${appBinary}"
  [[ "${platformType}" == "macOS" && "${archVar}" == "arm64" ]] && $perlVar 's|\x91\xE2\x43\x02\x91\K..\x00\x94(?=\xF8\x03)|\x60\x00\x80\xD2|' "${appBinary}"
  $perlVar 's/(return ).{1,3}(\?(.{1,4}createElement|\(.{1,7}.jsxs\))\(.{3,7}\{displayText:"Debug Tools")/$1true$2/' "${xpuiJs}"
  $perlVar 's|(.{1,5},\{role.{25,35}children."Locales"\}\))||' "${xpuiJs}"
  printf "\xE2\x9C\x94\x20\x45\x6E\x61\x62\x6C\x65\x64\x20\x64\x65\x76\x65\x6C\x6F\x70\x65\x72\x20\x6D\x6F\x64\x65\n"
fi

if [[ "${excludeExp}" ]]; then
  printf "\xE2\x9C\x94\x20\x53\x6B\x69\x70\x70\x65\x64\x20\x65\x78\x70\x65\x72\x69\x6D\x65\x6E\x74\x61\x6C\x20\x66\x65\x61\x74\x75\x72\x65\x73\n"
else
  [[ "${paidPremium}" ]] && $perlVar 's|addYourDJToLibraryOnPlayback",description:"Add Your DJ to library on playback",default:\K!1|true|s' "${xpuiJs}" #addYourDJToLibraryOnPlayback
  $perlVar 's|Enable support for adding a playlist to another playlist",default:\K!1|true|s' "${xpuiJs}" #enableAddPlaylistToPlaylist
  $perlVar 's|Enable the cover art modal on the Album page",default:\K!1|true|s' "${xpuiJs}" #enableAlbumCoverArtModal
  $perlVar 's|Enable album prerelease pages",default:\K!1|true|s' "${xpuiJs}" #enableAlbumPrerelease
  $perlVar 's|Enable Aligned Curation",default:\K!1|true|s' "${xpuiJs}" #enableAlignedCuration
  $perlVar 's|Titan Easter egg turning progress bar red when playing official soundtrack",default:\K!1|true|s' "${xpuiJs}" #enableAttackOnTitanEasterEgg
  $perlVar 's|Enable Audiobooks feature on ClientX",default:\K!1|true|s' "${xpuiJs}" #enableAudiobooks
  $perlVar 's|Enable a different heart button for Bad Bunny",default:\K!1|true|s' "${xpuiJs}" #enableBadBunnyEasterEgg
  $perlVar 's|Enable showing balloons on album release date anniversaries",default:\K!1|true|s' "${xpuiJs}" #enableAlbumReleaseAnniversaries
  $perlVar 's|rendering subtitles on the betamax SDK on DesktopX",default:\K!1|true|s' "${xpuiJs}" #enableBetamaxSdkSubtitlesDesktopX
  $perlVar 's|Panther Easter egg turning progress bar purple when playing official soundtrack",default:\K!1|true|s' "${xpuiJs}" #enableBlackPantherEasterEgg
  $perlVar 's|Enable block users feature in clientX",default:\K!1|true|s' "${xpuiJs}" #enableBlockUsers
  $perlVar 's|Fetch Browse data from Pathfinder",default:\K!1|true|s' "${xpuiJs}" #enableBrowseViaPathfinder
  $perlVar 's|Use carousels on Home",default:\K!1|true|s' "${xpuiJs}" #enableCarouselsOnHome
  $perlVar 's|Enable option in settings to clear all downloads",default:\K!1|true|s' "${xpuiJs}" #enableClearAllDownloads
  $perlVar 's|Enable Tour Card on This is Playlist",default:\K!1|true|s' "${xpuiJs}" #enableConcertsForThisIsPlaylist
  $perlVar 's|Enable Save & Retrieve feature for concerts",default:\K!1|true|s' "${xpuiJs}" #enableConcertsInterested
  $perlVar 's|Enable Concerts Near You Playlist",default:\K!1|true|s' "${xpuiJs}" #enableConcertsNearYou
  $perlVar 's|Enable the "Sold by Spotify" tab for concerts.,default:\K!1|true|s' "${xpuiJs}" #enableConcertsSoldBySpotify
  $perlVar 's|Display ticket price on Event page",default:\K!1|true|s' "${xpuiJs}" #enableConcertsTicketPrice
  $perlVar 's|Enable Cultural Moment pagess",default:\K!.(?=})|false|s' "${xpuiJs}" #enableCulturalMoments
  $perlVar 's|Enable splitting the device list based on local network",default:\K!1|true|s' "${xpuiJs}" #enableDeviceListSplit
  $perlVar 's|Enable a condensed disography shelf on artist pages",default:\K!1|true|s' "${xpuiJs}" #enableDiscographyShelf
  $perlVar 's|Enable the dynamic normalizer.compressor",default:\K!1|true|s' "${xpuiJs}" #enableDynamicNormalizer
  $perlVar 's|Enable Enhance Playlist UI and functionality for end-users",default:\K!1|true|s' "${xpuiJs}" #enableEnhancePlaylistProd
  $perlVar 's|Enable Enhance Liked Songs UI and functionality",default:\K!1|true|s' "${xpuiJs}" #enableEnhanceLikedSongs
  $perlVar 's|Enable audio equalizer for Desktop and Web Player",default:\K!1|true|s' "${xpuiJs}" #enableEqualizer
  $perlVar 's|control if followers and following lists are shown on profile",default:\K!1|true|s' "${xpuiJs}" #enableShowFollowsSetting
  $perlVar 's|Enable the option to Forget Devices",default:\K!1|true|s' "${xpuiJs}" #enableForgetDevice
  [[ "${paidPremium}" ]] && $perlVar 's|Enable Hifi indicator and flyout",default:\K!1|true|s' "${xpuiJs}" #enableHifi
  $perlVar 's|Enable Ignore In Recommendations for desktop and web",default:\K!1|true|s' "${xpuiJs}" #enableIgnoreInRecommendations
  $perlVar 's|Enables the new inline playlist curation tools",default:\K!1|true|s' "${xpuiJs}" #enableInlineCuration
  $perlVar 's|Enables the "Just Press Play" feature.,default:\K!1|true|s' "${xpuiJs}" #enableJustPressPlay
  $perlVar 's|Enable Liked Songs section on Artist page",default:\K!1|true|s' "${xpuiJs}" #enableArtistLikedSongs
  $perlVar 's|Enable list view for Live Events feed",default:\K!1|true|s' "${xpuiJs}" #enableLiveEventsListView
  $perlVar 's|With this enabled, clients will check whether tracks have lyrics available",default:\K!1|true|s' "${xpuiJs}" #enableLyricsCheck
  $perlVar 's|Enable Lyrics match labels in search results",default:\K!1|true|s' "${xpuiJs}" #ENABLE_LYRICS_MATCH
  $perlVar 's|Enable the new fullscreen lyrics page",default:\K!1|true|s' "${xpuiJs}" #enableLyricsNew
  $perlVar 's|Show "Made For You" entry point in the left sidebar.,default:\K!1|true|s' "${xpuiJs}" #enableMadeForYou
  $perlVar 's|Mermaid playlist easter egg",default:\K!1|true|s' "${xpuiJs}" #enableMyLittleMermaidEasterEgg
  $perlVar 's|Mermaid playlist easter egg video background",default:\K!1|true|s' "${xpuiJs}" #enableMyLittleMermaidEasterEggVideo
  $perlVar 's|Enable New Entity Headers",default:\K!1|true|s' "${xpuiJs}" #enableNewEntityHeaders
  $perlVar 's|Enable the new episodes view",default:\K!1|true|s' "${xpuiJs}" #enableNewEpisodes
  $perlVar 's|Enable showing podcast transcripts on desktop and web player",default:\K!1|true|s' "${xpuiJs}" #enableNewPodcastTranscripts
  $perlVar 's|Enable the next best episode block on the show page",default:\K!1|true|s' "${xpuiJs}" #enableNextBestEpisode
  $perlVar 's|Enable pick and shuffle",default:\K!.(?=})|false|s' "${xpuiJs}" #enablePickAndShuffle
  $perlVar 's|Enable the PiP Mini Player",default:\K!1|true|s' "${xpuiJs}" #enablePiPMiniPlayer
  $perlVar 's|Load context to enable play button on first load",default:\K!1|true|s' "${xpuiJs}" #enablePlayAtFirstTap
  $perlVar 's|Enables new playlist creation flow in Web Player and DesktopX",default:\K!1|true|s' "${xpuiJs}" #enablePlaylistCreationFlow
  $perlVar 's|Enable Playlist Permissions flows for Prod",default:\K!1|true|s' "${xpuiJs}" #enablePlaylistPermissionsProd
  $perlVar 's|Enable read along transcripts in the NPV",default:\K!1|true|s' "${xpuiJs}" #enableReadAlongTranscripts
  $perlVar 's|Enable the slide-in.out transition on the sidebars in the RootGrid",default:\K!1|true|s' "${xpuiJs}" #enableRootGridAnimations
  $perlVar 's|filter playlists when trying to add songs to a playlist using the contextmenu",default:\K!1|true|s' "${xpuiJs}" #enableSearchBox
  $perlVar 's|Enable new Search experience",default:\K!1|true|s' "${xpuiJs}" #enableSearchV3
  $perlVar 's|Display share icon for sharing an event",default:\K!1|true|s' "${xpuiJs}" #enableShareEvent
  $perlVar 's|Enable silence trimming in podcasts",default:\K!1|true|s' "${xpuiJs}" #enableSilenceTrimmer
  $perlVar 's/,(.\.isOwnedBySelf&&)((\(.{0,11}\)|..createElement)\(.{1,3}Fragment,.+?{(uri:.|spec:.),(uri:.|spec:.).+?contextmenu.create-similar-playlist"\)}\),)/,$2$1/s' "${xpuiJs}" #createSimilarPlaylist
  $perlVar 's|Enables SingAlong in the Lyrics feature",default:\K!1|true|s' "${xpuiJs}" #enableSingAlong
  $perlVar 's|playback speed range from 0.5-3.5 with every 0.1 increment",default:\K!1|true|s' "${xpuiJs}" #enableSmallPlaybackSpeedIncrements
  (($(ver "${clientVer}") >= $(ver "1.2.14.1141"))) && $perlVar 's|Enable Smart Shuffle",default:\K!1|true|s' "${xpuiJs}" #enableSmartShuffle
  $perlVar 's|Display sold by spotify shelf on All Events tab",default:\K!1|true|s' "${xpuiJs}" #enableSoldBySpotifyShelf
  [[ "${paidPremium}" ]] && $perlVar 's|group listening sessions for Desktop",default:\K!.(?=})|true|s' "${xpuiJs}" #enableSocialConnectOnDesktop
  $perlVar 's|Enable the Stranger Things upside down Easter Egg",default:\K!1|true|s' "${xpuiJs}" #enableStrangerThingsEasterEgg
  $perlVar 's|label in the subtitle picker.,default:\K!1|true|s' "${xpuiJs}" #enableSubtitlesAutogeneratedLabel
  $perlVar 's|Enable ability to toggle playlist column visibility",default:\K!1|true|s' "${xpuiJs}" #enableTogglePlaylistColumns
  $perlVar 's|Enables editing of user.s own profile in Web Player and DesktopX",default:\K!1|true|s' "${xpuiJs}" #enableUserProfileEdit
  (($(ver "${clientVer}") >= $(ver "1.2.12.902"))) && $perlVar 's|Enable the what.s new feed panel",default:\K!1|true|s' "${xpuiJs}" #enableWhatsNewFeed
  $perlVar 's|Enable Whats new feed in the main view",default:\K!1|true|s' "${xpuiJs}" #enableWhatsNewFeedMainView
  $perlVar 's|jump to the first matching item",default:\K!1|true|s' "${xpuiJs}" #enableYLXTypeaheadSearch
  [[ "${paidPremium}" ]] && $perlVar 's|Enables the .Your DJ. feature.,default:\K!1|true|s' "${xpuiJs}" #enableYourDJ
  $perlVar 's|Show Wrapped banner on wrapped genre page",default:\K!1|true|s' "${xpuiJs}" #showWrappedBanner
  printf "\xE2\x9C\x94\x20\x45\x6E\x61\x62\x6C\x65\x64\x20\x65\x78\x70\x65\x72\x69\x6D\x65\x6E\x74\x61\x6C\x20\x66\x65\x61\x74\x75\x72\x65\x73\n"
fi

if [[ "${oldUi}" ]]; then
  (($(ver "${clientVer}") >= $(ver "1.1.93.896") && $(ver "${clientVer}") <= $(ver "1.2.13.661"))) && { $perlVar "${disableYLXSidebar}" "${xpuiJs}"; $perlVar "${disableRightSidebar}" "${xpuiJs}"; }
  (($(ver "${clientVer}") >= $(ver "1.1.93.896") && $(ver "${clientVer}") <= $(ver "1.2.13.661"))) && printf "\xE2\x9C\x94\x20\x45\x6E\x61\x62\x6C\x65\x64\x20\x6F\x6C\x64\x20\x55\x49\n"
  (($(ver "${clientVer}") > $(ver "1.2.13.661"))) && { echo -e "\n${yellow}Warning:${clear} Old UI not supported in clients after v1.2.13.661...\n" >&2; unset oldUi; }
fi

if [[ -z "${oldUi+x}" ]] && (($(ver "${clientVer}") > $(ver "1.1.93.896"))); then
  (($(ver "${clientVer}") > $(ver "1.1.93.896") && $(ver "${clientVer}") < $(ver "1.1.97.956"))) && $perlVar "${enableNavAltExperiment}" "${xpuiJs}"
  (($(ver "${clientVer}") >= $(ver "1.1.97.956") && $(ver "${clientVer}") < $(ver "1.2.3.1107"))) && $perlVar "${enableNavAltExperiment2}" "${xpuiJs}"
  (($(ver "${clientVer}") >= $(ver "1.1.97.962") && $(ver "${clientVer}") <= $(ver "1.2.13.661"))) && $perlVar "${enableYLXSidebar}" "${xpuiJs}"
  (($(ver "${clientVer}") >= $(ver "1.1.98.683"))) && $perlVar "${enableRightSidebar}" "${xpuiJs}"
  (($(ver "${clientVer}") >= $(ver "1.2.7.1264"))) && { $perlVar "${enableRightSidebarCredits}" "${xpuiJs}"; $perlVar "${enableRightSidebarMerchFallback}" "${xpuiJs}"; $perlVar "${enableRightSidebarTransitionAnimations}" "${xpuiJs}"; }
  (($(ver "${clientVer}") >= $(ver "1.2.0.1165"))) && $perlVar "${enableRightSidebarColors}" "${xpuiJs}"
  (($(ver "${clientVer}") >= $(ver "1.2.0.1165"))) && $perlVar "${enableRightSidebarLyrics}" "${xpuiJs}"
  (($(ver "${clientVer}") >= $(ver "1.2.16.947"))) && $perlVar "${enableRightSidebarArtistEnhanced}" "${xpuiJs}"
  (($(ver "${clientVer}") >= $(ver "1.2.7.1264"))) && $perlVar "${enablePanelSizeCoordination}" "${xpuiJs}"
  printf "\xE2\x9C\x94\x20\x45\x6E\x61\x62\x6C\x65\x64\x20\x6E\x65\x77\x20\x55\x49\n"
fi

if [[ "${hideNonMusic}" ]] && (($(ver "${clientVer}") >= $(ver "1.1.70.610"))); then
  (($(ver "${clientVer}") < $(ver "1.1.93.896"))) && $perlVar "${hidePodcasts}" "${xpuiJs}"
  (($(ver "${clientVer}") >= $(ver "1.1.93.896"))) && $perlVar "${hidePodcasts2}" "${xpuiJs}"
  printf "\xE2\x9C\x94\x20\x52\x65\x6D\x6F\x76\x65\x64\x20\x6E\x6F\x6E\x2D\x6D\x75\x73\x69\x63\x20\x63\x61\x74\x65\x67\x6F\x72\x69\x65\x73\x20\x6F\x6E\x20\x68\x6F\x6D\x65\x20\x73\x63\x72\x65\x65\x6E\n"
fi

$perlVar "${enableUserFraudCanvas}" "${xpuiJs}"
$perlVar "${enableUserFraudCspViolation}" "${xpuiJs}"
$perlVar "${enableUserFraudSignals}" "${xpuiJs}"
$perlVar "${enableUserFraudVerification}" "${xpuiJs}"
$perlVar "${enableUserFraudVerificationRequest}" "${xpuiJs}"
$perlVar "${logV3}" "${xpuiJs}"
$perlVar "${logSentry}" "${vendorXpuiJs}"
printf "\xE2\x9C\x94\x20\x52\x65\x6D\x6F\x76\x65\x64\x20\x6C\x6F\x67\x67\x69\x6E\x67\n"

$perlVar 's;((..createElement|children:\(.{1,7}\))\(.{1,7},\{source:).{1,7}get\("about.copyright",.\),paragraphClassName:.(?=\}\));$1"<h3>About SpotX / SpotX-Bash</h3><br><details><summary><svg xmlns='\''http://www.w3.org/2000/svg'\'' width='\''20'\'' height='\''20'\'' viewBox='\''0 0 24 24'\''><path d='\''M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z'\'' fill='\''#fff'\''/></svg> Github</summary><a href='\''https://github.com/amd64fox/SpotX'\''>SpotX \(Windows\)</a><br><a href='\''https://github.com/jetfir3/SpotX-Bash'\''>SpotX-Bash \(Linux/macOS\)</a><br><br/></details><details><summary><svg xmlns='\''http://www.w3.org/2000/svg'\'' width='\''20'\'' height='\''20'\'' viewBox='\''0 0 24 24'\''><path id='\''telegram-1'\'' d='\''M18.384,22.779c0.322,0.228 0.737,0.285 1.107,0.145c0.37,-0.141 0.642,-0.457 0.724,-0.84c0.869,-4.084 2.977,-14.421 3.768,-18.136c0.06,-0.28 -0.04,-0.571 -0.26,-0.758c-0.22,-0.187 -0.525,-0.241 -0.797,-0.14c-4.193,1.552 -17.106,6.397 -22.384,8.35c-0.335,0.124 -0.553,0.446 -0.542,0.799c0.012,0.354 0.25,0.661 0.593,0.764c2.367,0.708 5.474,1.693 5.474,1.693c0,0 1.452,4.385 2.209,6.615c0.095,0.28 0.314,0.5 0.603,0.576c0.288,0.075 0.596,-0.004 0.811,-0.207c1.216,-1.148 3.096,-2.923 3.096,-2.923c0,0 3.572,2.619 5.598,4.062Zm-11.01,-8.677l1.679,5.538l0.373,-3.507c0,0 6.487,-5.851 10.185,-9.186c0.108,-0.098 0.123,-0.262 0.033,-0.377c-0.089,-0.115 -0.253,-0.142 -0.376,-0.064c-4.286,2.737 -11.894,7.596 -11.894,7.596Z'\'' fill='\''#fff'\''/></svg> Telegram</summary><a href='\''https://t.me/spotify_windows_mod'\''>SpotX Channel</a><br><a href='\''https://t.me/SpotxCommunity'\''>SpotX Community</a><br><br/></details><details><summary><svg xmlns='\''http://www.w3.org/2000/svg'\'' width='\''20'\'' height='\''20'\'' viewBox='\''0 0 24 24'\''><path d='\''M12 2c5.514 0 10 4.486 10 10s-4.486 10-10 10-10-4.486-10-10 4.486-10 10-10zm0-2c-6.627 0-12 5.373-12 12s5.373 12 12 12 12-5.373 12-12-5.373-12-12-12zm1.25 17c0 .69-.559 1.25-1.25 1.25-.689 0-1.25-.56-1.25-1.25s.561-1.25 1.25-1.25c.691 0 1.25.56 1.25 1.25zm1.393-9.998c-.608-.616-1.515-.955-2.551-.955-2.18 0-3.59 1.55-3.59 3.95h2.011c0-1.486.829-2.013 1.538-2.013.634 0 1.307.421 1.364 1.226.062.847-.39 1.277-.962 1.821-1.412 1.343-1.438 1.993-1.432 3.468h2.005c-.013-.664.03-1.203.935-2.178.677-.73 1.519-1.638 1.536-3.022.011-.924-.284-1.719-.854-2.297z'\'' fill='\''#fff'\''/></svg> FAQ</summary><a href='\''https://te.legra.ph/SpotX-FAQ-09-19'\''>Windows</a><br><a href='\''https://github.com/jetfir3/SpotX-Bash/wiki/SpotX%E2%80%90Bash-FAQ'\''>Linux/macOS</a></details><br><h4>DISCLAIMER</h4>SpotX is a modified version of the official Spotify&reg\; client, provided &quot\;as is&quot\; for the purpose of evaluation at user'\''s own risk. Source code for SpotX is available separately and free of charge under open source software license agreements. SpotX is not affiliated with Spotify&reg\;, Spotify AB or Spotify Group.<br><br>Spotify&reg\; is a registered trademark of Spotify Group.";' "${xpuiDesktopModalsJs}"

echo -e "\n//# SpotX was here" >> "${xpuiJs}"
rm "${xpuiSpa}"
(cd "${xpuiDir}" || exit; zip -qq -r ../xpui.spa .)
rm -rf "${xpuiDir}"

if [[ "${platformType}" == "macOS" ]]; then
  [[ "${blockUpdates}" ]] && { $perlVar 's|\x00\K\x77(?=\x67\x3A\x2F\x2F\x64)|\x00|' "${appBinary}"; printf "\xE2\x9C\x94\x20\x42\x6C\x6F\x63\x6B\x65\x64\x20\x61\x75\x74\x6F\x6D\x61\x74\x69\x63\x20\x75\x70\x64\x61\x74\x65\x73\n"; }
  [[ -z "${skipCodesign+x}" ]] && { codesign -f -s - --deep "${appPath}" 2>/dev/null; printf "\xE2\x9C\x94\x20\x43\x6F\x64\x65\x73\x69\x67\x6E\x65\x64\x20\x53\x70\x6F\x74\x69\x66\x79\n"; }
  xattr -cr "${appPath}" 2>/dev/null
fi

printf "\xE2\x9C\x94\x20\x46\x69\x6E\x69\x73\x68\x65\x64\n\n"
exit 0
