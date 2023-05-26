#!/usr/bin/env bash

SXB_VERSION="1.2.10.751"

case $(uname | tr '[:upper:]' '[:lower:]') in
  darwin*) PLATFORM_TYPE='macOS' ;;
        *) PLATFORM_TYPE='Linux' ;;
esac

CLEAR='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'

DISABLEMADEFORYOU_OPT='false'
DISABLESEARCHV3_OPT='false'
DISABLELEFTSIDEBAR_OPT='false'
DISABLERIGHTSIDEBAR_OPT='false'
DISABLESIDEBARCOLORS_OPT='false'
DISABLESIDEBARLYRICS_OPT='false'
INSTALLCLIENT_OPT='false'
SKIPCODESIGN_OPT='false'
CACHE_FLAG='false'
EXCLUDE_EXPERIMENTAL_FLAG='false'
FORCE_SPOTX_FLAG='false'
#HIDE_PODCASTS_FLAG='false'
INTERACTIVE_FLAG='false'
OLD_UI_FLAG='false'
PATH_FLAG=''
PREMIUM_FLAG='false'
UNINSTALL_FLAG='false'
UPDATE_FLAG='false'
NOTINSTALLED_VAR='false'

show_version () {
	echo -e "SpotX-Bash version ${SXB_VERSION}\n"
	[[ $(ver "${SXB_VERSION}") -gt $(ver "1.1.0.0") && $(ver "${SXB_VERSION}") -lt $(ver "${SXB_LIVE}") ]] && echo -e "${VERSION_CK3}"
	exit
}

if [[ "${PLATFORM_TYPE}" == "macOS" ]]; then
	show_help () {
		echo -e \
"Options:
-c        : clear Spotify app cache
--disableleftsidebar
--disablemadeforyou
--disablemadeforyou
--disablerightsidebar
--disablesidebarcolors
--disablesidebarlyrics
-e        : exclude all experimental features
-f        : force SpotX to run
-h        : print this help message (also --help)
-i        : enable interactive mode
--installclient
-o        : use old home screen UI
-p        : set if paid premium-tier subscriber
-P [path] : set path to Spotify
-r        : remove non-music categories on home screen
--skipcodesign
-u        : block Spotify updates
-U        : uninstall SpotX
-v        : print SpotX version (also --version)
"
	exit
}
else 
	show_help () {
		echo -e \
"Options:
-c        : clear Spotify app cache
--disableleftsidebar
--disablemadeforyou
--disablerightsidebar
--disablesidebarcolors
--disablesidebarlyrics
-e        : exclude all experimental features
-f        : force SpotX to run
-h        : print this help message (also --help)
-i        : enable interactive mode
-o        : use old home screen UI
-p        : set if paid premium-tier subscriber
-P [path] : set path to Spotify
-r        : remove non-music categories on home screen
-U        : uninstall SpotX
-v        : print SpotX version (also --version)
"
	exit
}
fi


while getopts 'ceF:fhioP:prUuv-:' flag; do
  case "${flag}" in
    -)
      case "${OPTARG}" in
        disablemadeforyou) DISABLEMADEFORYOU_OPT='true' ;;
        disablesearchv3) DISABLESEARCHV3_OPT='true' ;;
        disableleftsidebar) DISABLELEFTSIDEBAR_OPT='true' ;;
        disablerightsidebar) DISABLERIGHTSIDEBAR_OPT='true' ;;
        disablesidebarcolors) DISABLESIDEBARCOLORS_OPT='true' ;;
        disablesidebarlyrics) DISABLESIDEBARLYRICS_OPT='true' ;;
        help) show_help ;;
        installclient) INSTALLCLIENT_OPT='true' ;;
        logo) 
					clear
					echo "
					████╗███╗  ███╗ █████╗█╗  █╗  ███╗  ██╗ ████╗█╗ █╗
					█╔══╝█╔═█╗█╔══█╗╚═█╔═╝╚█╗█╔╝  █╔═█╗█╔═█╗█╔══╝█║ █║
					████╗███╔╝█║  █║  █║   ╚█╔╝██╗███╔╝████║████╗████║
					╚══█║█╔═╝ █║  █║  █║   █╔█╗╚═╝█╔═█╗█╔═█║╚══█║█╔═█║
					████║█║   ╚███╔╝  █║  █╔╝ █╗  ███╔╝█║ █║████║█║ █║
					╚═══╝╚╝    ╚══╝   ╚╝  ╚╝  ╚╝  ╚══╝ ╚╝ ╚╝╚═══╝╚╝ ╚╝
					"
					;;
        skipcodesign) SKIPCODESIGN_OPT='true' ;;
        version) show_version ;;
        *)
          echo -e "${RED}Error:${CLEAR} Option not supported. Exiting...\n"
          exit ;;
      esac ;;
    c) CACHE_FLAG='true' ;;
    e) EXCLUDE_EXPERIMENTAL_FLAG='true' ;;
    F)
      FORCE_VERSION_FLAG="${OPTARG}"
      CLIENT_VERSION="${FORCE_VERSION_FLAG}" ;;
    f) FORCE_SPOTX_FLAG='true' ;;
    h) show_help ;;
    i) INTERACTIVE_FLAG='true' ;;
    o) OLD_UI_FLAG='true' ;;
    p) PREMIUM_FLAG='true' ;;
    P)
      PATH_FLAG="${OPTARG}"
      INSTALL_PATH="${PATH_FLAG}" ;;
    r) REMOVE_PODCASTS_FLAG='true' ;;
    U) UNINSTALL_FLAG='true' ;;
    u) UPDATE_FLAG='true' ;;
    v) show_version ;;
    *)
      echo -e "${RED}Error:${CLEAR} Option not supported. Exiting...\n"
      exit ;;
  esac
done

SXB_LIVE="$(curl -sL $(echo "=g2cugHdvB3cvcXYy9SMidjZ0QzMkRTOwMWZlVTMmRTY2EmYlRGOmNGMzgDOl9yMylmZ0Vmav02bj5iY1hGdpdmL0NXan9yL6MHc0RHa" | rev | base64 --decode) | grep "g>" | cut -d ' ' -f12- 2>/dev/null)"
VERSION_CK1="==gbcxFazFmY4R3bwN3LkdmLzlGIABSZsJWYslWY2FGIzlGI9JVQFx0Q7RiI9VkVJx0XCh1U7RiI95URFJ1R7RCIu9WazJXZW5GXc5CZlRXYkRXdvBycpBCazFmQtgFdvB3UgY2bg42bpNnclZHIzlGaUBSfSFURMN0ekozZulmbyF2V9d1TMxURZtHJ"
VERSION_CK2=$(echo ${VERSION_CK1} | rev | base64 --decode)
VERSION_CK3=$(eval echo "${VERSION_CK2}")
function ver { echo "$@" | awk -F. '{ printf("%d%03d%04d%05d\n", $1,$2,$3,$4); }'; }

if [[ "${PLATFORM_TYPE}" == "macOS" && "${SKIPCODESIGN_OPT}" == "false" ]]; then
	command -v codesign >/dev/null || { echo -e "\n${RED}Error:${CLEAR} codesign command not found.\nInstall Xcode Command Line Tools then try again. Exiting...\n\nEnter the following command in Terminal to install:\n${YELLOW}xcode-select --install${CLEAR}\n" >&2
	exit 1
	}
fi
command -v perl >/dev/null || { echo -e "\n${RED}Error:${CLEAR} perl command not found.\nInstall perl on your system then try again. Exiting...\n" >&2; exit 1; }
command -v unzip >/dev/null || { echo -e "\n${RED}Error:${CLEAR} unzip command not found.\nInstall unzip on your system then try again. Exiting...\n" >&2; exit 1; }
command -v zip >/dev/null || { echo -e "\n${RED}Error:${CLEAR} zip command not found.\nInstall zip on your system then try again. Exiting...\n" >&2; exit 1; }

if [[ "${PLATFORM_TYPE}" == "macOS" ]]; then
  #BD86="6JGduAjM50iMiNWZxU2Y5cmL"
  #BD64="6JGduMjM50iMiNWZxU2Y5cmL"
  osascript -e 'quit app "Spotify"'
  #if [[ $(sysctl -n machdep.cpu.brand_string) =~ "Apple" ]]; then
		#ARCH='arm64'
    #BLD64=$(echo ${BD64} | rev | base64 -D)
		#BLDNO="${BLD64}"
	#else
		#ARCH='x86_64'
		#BLD86=$(echo ${BD86} | rev | base64 -D)
		#BLDNO="${BLD86}"
	#fi
  if [[ ${OSTYPE:6} -lt 15 ]]; then
		echo -e "\n${RED}Error:${CLEAR} OS version unsupported. Exiting...\n"
	fi
  #STRING1="90TUMRjTzImdR5mYsx2RipWOTp1aG12YuJEWkZHOykVd0ckWq5kbMxmUXlVekd0YxkTeMZTTINGMShUY"
  #STRING2="==QPwMlWwY0RadnVzIGMWhVW0tmbaBnUzI2dONDT"
  #STRING3="=0DMzQ1TSVEVDRHSKlTNwQlSOxWVGpVMYNEaxU1NSNlZ5FlRVdjUTZWSOtWVCRHSKljREZVU0hkS"
  #PT1=$(echo ${STRING1} | rev | base64 -D | base64 -D)
  #PT2=$(echo ${STRING2} | rev | base64 -D | base64 -D)
  #GRAB1=$(echo ${STRING3} | rev | base64 -D | base64 -D)
  #GRAB2=$(eval echo ${GRAB1})
  if [ -z ${INSTALL_PATH+x} ]; then
    APP_PATH="/Applications/Spotify.app"
    if [[ -d "${HOME}${APP_PATH}" ]]; then
      INSTALL_PATH="${HOME}/Applications"
    elif [[ -d "${APP_PATH}" ]]; then
      INSTALL_PATH="/Applications"
    else
      INTERACTIVE_FLAG='true'
      NOTINSTALLED_VAR='true'
      INSTALL_PATH="/Applications"
      echo -e "\n${YELLOW}Warning:${CLEAR} Spotify not found. Starting interactive mode...\n"; fi
  else
    if [[ -d "${INSTALL_PATH}/Spotify.app" ]]; then
      : #INSTALL_PATH="${INSTALL_PATH}"
    else
      echo -e "\n${RED}Error:${CLEAR} Spotify not found. Exiting...\n"
		fi
	fi
fi

if [[ "${PLATFORM_TYPE}" == "Linux" ]]; then
  if [ -z ${INSTALL_PATH+x} ]; then
		INSTALL_PATH="$(readlink -e "$(type -p spotify)" 2>/dev/null | rev | cut -d/ -f2- | rev)"
    if [[ -d "${INSTALL_PATH}" && "${INSTALL_PATH}" != "/usr/bin" ]]; then
			echo -e "Found Spotify directory: ${INSTALL_PATH}\n"
    elif [[ ! -d "${INSTALL_PATH}" ]]; then
      echo -e "${YELLOW}Warning:${CLEAR} Spotify not found in PATH. Searching for Spotify directory...\n"
      INSTALL_PATH=$(timeout 10 find / -type f -path "*/spotify*Apps/*" -name "xpui.spa" -size -7M -size +3M -print -quit 2>/dev/null | rev | cut -d/ -f3- | rev)
      if [[ -d "${INSTALL_PATH}" ]]; then
				echo -e "Found Spotify Directory: ${INSTALL_PATH}\n"
      elif [[ ! -d "${INSTALL_PATH}" ]]; then
				echo -e "${RED}Error:${CLEAR} Spotify directory not found.\nSet directory path with '-P' flag. Exiting...\n"
				exit
			fi
    elif [[ "${INSTALL_PATH}" == "/usr/bin" ]]; then
      echo -e "\n${YELLOW}Warning:${CLEAR} Spotify PATH is set to /usr/bin, searching for Spotify directory...\n"
      INSTALL_PATH=$(timeout 10 find / -type f -path "*/spotify*Apps/*" -name "xpui.spa" -size -7M -size +3M -print -quit 2>/dev/null | rev | cut -d/ -f3- | rev)
      if [[ -d "${INSTALL_PATH}" && "${INSTALL_PATH}" != "/usr/bin" ]]; then
				echo -e "Found Spotify directory: ${INSTALL_PATH}\n"
      elif [[ "${INSTALL_PATH}" == "/usr/bin" ]] || [[ ! -d "${INSTALL_PATH}" ]]; then
				echo -e "${RED}Error:${CLEAR} Spotify directory not found.\nSet directory path with '-P' flag. Exiting...\n"
				exit
			fi
		fi
  else
    if [[ ! -d "${INSTALL_PATH}" ]]; then
			echo -e "${RED}Error:${CLEAR} Directory path set by '-P' not found. Exiting...\n"
			exit
    elif [[ ! -f "${INSTALL_PATH}/Apps/xpui.spa" ]]; then
			echo -e "${RED}Error:${CLEAR} Spotify not found in path set by '-P'.\nConfirm directory and try again or re-install Spotify. Exiting...\n"
			exit
		fi
	fi
fi

if [[ "${PLATFORM_TYPE}" == "macOS" ]]; then
  APP_PATH="${INSTALL_PATH}/Spotify.app"
  APP_BINARY="${APP_PATH}/Contents/MacOS/Spotify"
  APP_BAK="${APP_PATH}/Contents/MacOS/Spotify.bak"
  CACHE_PATH="${HOME}/Library/Caches/com.spotify.client"
  XPUI_PATH="${INSTALL_PATH}/Spotify.app/Contents/Resources/Apps"
  if [[ "${SKIPCODESIGN_OPT}" == "true" ]]; then
		echo -e "${YELLOW}Warning:${CLEAR} Codesigning has been skipped.\nIf launching Spotify fails, reinstallation is needed.\n"
	fi
fi
if [[ "${PLATFORM_TYPE}" == "Linux" ]]; then
  APP_BINARY="${INSTALL_PATH}/spotify"
  APP_BAK="${INSTALL_PATH}/spotify.bak"
  CACHE_PATH="${HOME}/.cache/spotify/"
  XPUI_PATH="${INSTALL_PATH}/Apps"; fi
XPUI_DIR="${XPUI_PATH}/xpui"
XPUI_BAK="${XPUI_PATH}/xpui.bak"
XPUI_SPA="${XPUI_PATH}/xpui.spa"
XPUI_JS="${XPUI_DIR}/xpui.js"
XPUI_CSS="${XPUI_DIR}/xpui.css"
HOME_HPTO_JS="${XPUI_DIR}/home-hpto.js"
#HOME_V2_JS="${XPUI_DIR}/home-v2.js"
VENDOR_XPUI_JS="${XPUI_DIR}/vendor~xpui.js"

if [[ "${PLATFORM_TYPE}" == "macOS" ]]; then
	if [[ "${NOTINSTALLED_VAR}" == 'false' ]]; then
		if [ -z ${FORCE_VERSION_FLAG+x} ]; then
			CLIENT_VERSION=$(awk '/CFBundleShortVersionString/{getline; print}' "${INSTALL_PATH}/Spotify.app/Contents/Info.plist" 2>/dev/null | cut -d\> -f2- | rev | cut -d. -f2- | rev)
		fi
	fi
fi
if [[ "${PLATFORM_TYPE}" == "Linux" ]]; then
	if [ -z ${FORCE_VERSION_FLAG+x} ]; then
		CLIENT_VERSION=$("${INSTALL_PATH}"/spotify --version | cut -d " " -f3- | rev | cut -d. -f2- | rev)
	fi
fi

PERL="perl -pi -w -e"

AD_ADS='s#/a\Kd(?=s/v1)|/a\Kd(?=s/v2/t)|/a\Kd(?=s/v2/se)#b#gs'
AD_AUDIO_ADS='s/(case .:|async enable\(.\)\{)(this.enabled=.+?\(.{1,3},"audio"\),|return this.enabled=...+?\(.{1,3},"audio"\))((;case 4:)?this.subscription=this.audioApi).+?this.onAdMessage\)/$1$3.cosmosConnector.increaseStreamTime(-100000000000)/'
AD_BILLBOARD='s|.(\?\[.{1,6}[a-zA-Z].leaderboard,)|false$1|'
AD_EMPTY_AD_BLOCK='s|adsEnabled:!0|adsEnabled:!1|'
AD_LOGIC='s|\x00\K\x61(?=\x64\x2D\x6C\x6F\x67\x69\x63\x2F\x73)|\x00|'
AD_PLAYLIST_SPONSORS='s|allSponsorships||'
AD_SLOT='s|\x00\K\x73(?=\x6C\x6F\x74\x73\x00)|\x00|'
AD_UPGRADE_BUTTON='s/(return|.=.=>)"free"===(.+?)(return|.=.=>)"premium"===/$1"premium"===$2$3"free"===/g'
AD_UPSELL='s|Enables quicksilver in-app messaging modal",default:\K!.(?=})|false|s'

ENABLE_ADD_PLAYLIST='s|Enable support for adding a playlist to another playlist",default:\K!1|true|s'
ENABLE_ATTACK_ON_TITAN_EASTER_EGG='s|Enable Attack on Titan Easter egg turning progress bar red when playing official soundtrack",default:\K!1|true|s'
ENABLE_AUDIOBOOKS_CLIENTX='s|Enable Audiobooks feature on ClientX",default:\K!1|true|s'
ENABLE_BAD_BUNNY='s|Enable a different heart button for Bad Bunny",default:\K!1|true|s'
ENABLE_BALLOONS='s|Enable showing balloons on album release date anniversaries",default:\K!1|true|s'
ENABLE_BLACK_PANTHER='s|Enable Black Panther Easter egg turning progress bar purple when playing official soundtrack",default:\K!1|true|s'
ENABLE_BLOCK_USERS='s|Enable block users feature in clientX",default:\K!1|true|s'
ENABLE_CAROUSELS='s|Use carousels on Home",default:\K!1|true|s'
ENABLE_CLEAR_DOWNLOADS='s|Enable option in settings to clear all downloads",default:\K!1|true|s'
ENABLE_CONCERTS_INTERESTED='s|Enable Save & Retrieve feature for concerts",default:\K!1|true|s'
ENABLE_CULTURAL_MOMENTS='s|Enable Cultural Moment pagess",default:\K!.(?=})|false|s'
ENABLE_DEVICE_LIST_LOCAL='s|Enable splitting the device list based on local network",default:\K!1|true|s'
ENABLE_DISCOG_SHELF='s|Enable a condensed disography shelf on artist pages",default:\K!1|true|s'
ENABLE_ENHANCE_PLAYLIST='s|Enable Enhance Playlist UI and functionality for end-users",default:\K!1|true|s'
ENABLE_ENHANCE_SONGS='s|Enable Enhance Liked Songs UI and functionality",default:\K!1|true|s'
ENABLE_EQUALIZER='s|Enable audio equalizer for Desktop and Web Player",default:\K!1|true|s'
ENABLE_FOLLOWERS_ON_PROFILE='s|Enable a setting to control if followers and following lists are shown on profile",default:\K!1|true|s'
ENABLE_FORGET_DEVICES='s|Enable the option to Forget Devices",default:\K!1|true|s'
ENABLE_HIFI='s|Enable Hifi indicator and flyout",default:\K!1|true|s'
ENABLE_IGNORE_REC='s|Enable Ignore In Recommendations for desktop and web",default:\K!1|true|s'
ENABLE_INLINE_CURATION='s|Enables the new inline playlist curation tools",default:\K!1|true|s'
ENABLE_JUST_PRESS_PLAY='s|Enables the "Just Press Play" feature.,default:\K!1|true|s'
ENABLE_LIKED_SONGS='s|Enable Liked Songs section on Artist page",default:\K!1|true|s'
ENABLE_LYRICS_CHECK='s|With this enabled, clients will check whether tracks have lyrics available",default:\K!1|true|s'
ENABLE_LYRICS_MATCH='s|Enable Lyrics match labels in search results",default:\K!1|true|s'
ENABLE_LYRICS_NEW='s|Enable the new fullscreen lyrics page",default:\K!1|true|s'
ENABLE_MADE_FOR_YOU='s|Show "Made For You" entry point in the left sidebar.,default:\K!1|true|s'
ENABLE_NEW_EPISODES='s|Enable the new episodes view",default:\K!1|true|s'
ENABLE_NEXT_BEST_EPISODE='s|Enable the next best episode block on the show page",default:\K!1|true|s'
ENABLE_PATHFINDER_DATA='s|Fetch Browse data from Pathfinder",default:\K!1|true|s'
ENABLE_PICK_AND_SHUFFLE='s|Enable pick and shuffle",default:\K!1|true|s'
ENABLE_PLAY_AT_FIRST_TAP='s|Load context to enable play button on first load",default:\K!1|true|s'
ENABLE_PLAYLIST_CREATION_FLOW='s|Enables new playlist creation flow in Web Player and DesktopX",default:\K!1|true|s'
ENABLE_PLAYLIST_PERMISSIONS_FLOWS='s|Enable Playlist Permissions flows for Prod",default:\K!1|true|s'
ENABLE_PODCAST_PLAYBACK_SPEED='s|playback speed range from 0.5-3.5 with every 0.1 increment",default:\K!1|true|s'
#ENABLE_PODCAST_TRANSCRIPTS='s|Enable showing podcast transcripts on desktop and web player",default:\K!1|true|s'
ENABLE_PODCAST_TRIMMING='s|Enable silence trimming in podcasts",default:\K!1|true|s'
ENABLE_SEARCH_BOX='s|Adds a search box so users are able to filter playlists when trying to add songs to a playlist using the contextmenu",default:\K!1|true|s'
ENABLE_SEARCH_V3='s|Enable new Search experience",default:\K!1|true|s'
ENABLE_SHOW_WRAPPED_BANNER='s|Show Wrapped banner on wrapped genre page",default:\K!1|true|s'
#ENABLE_SIMILAR_PLAYLIST='s/,(.\.isOwnedBySelf&&)((\(.{0,11}\)|..createElement)\(.{1,3}Fragment,.+?{(uri:.|spec:.),(uri:.|spec:.).+?contextmenu.create-similar-playlist"\)}\),)/,$2$1/s'
ENABLE_SING_ALONG='s|Enables SingAlong in the Lyrics feature",default:\K!1|true|s'
ENABLE_STRANGER_THINGS='s|Enable the Stranger Things upside down Easter Egg",default:\K!1|true|s'
ENABLE_SUBTITLES_AUTOGENERATED_LABEL='s|label in the subtitle picker.,default:\K!1|true|s'
ENABLE_USER_PROFILE_EDIT='s|Enables editing of user.s own profile in Web Player and DesktopX",default:\K!1|true|s'
ENABLE_YLX_Typeahead_Search='s|jump to the first matching item",default:\K!1|true|s'
ENABLE_YOUR_DJ='s|Enables the .Your DJ. feature.,default:\K!1|true|s'

NEW_UI='s|Enable the new home structure and navigation",values:.,default:\K..DISABLED|true|'
NEW_UI_2='s|Enable the new home structure and navigation",values:.,default:.\K.DISABLED|.ENABLED_CENTER|'
ENABLE_LEFT_SIDEBAR='s|Enable Your Library X view of the left sidebar",default:\K!1|true|s'
ENABLE_PANEL_SIZE_COORDINATION='s|Enable Panel Size Coordination between the left sidebar, the main view and the right sidebar",default:\K!1|true|s'
ENABLE_RIGHT_SIDEBAR='s|Enable the view on the right sidebar",default:\K!1|true|s'
ENABLE_RIGHT_SIDEBAR_COLORS='s|Extract background color based on artwork image",default:\K!1|true|s'
ENABLE_RIGHT_SIDEBAR_CREDITS='s|Show credits in the right sidebar",default:\K!1|true|s'
ENABLE_RIGHT_SIDEBAR_LYRICS='s|Show lyrics in the right sidebar",default:\K!1|true|s'
ENABLE_RIGHT_SIDEBAR_MERCH_FALLBACK='s|Allow merch to fallback to artist level merch if track level does not exist",default:\K!1|true|s'
ENABLE_RIGHT_SIDEBAR_TRANSITION_ANIMATIONS='s|Enable the slide-in.out transition on the right sidebar",default:\K!1|true|s'

HIDE_DL_QUALITY='s/(\(.,..jsxs\)\(.{1,3}|(.\(\).|..)createElement\(.{1,4}),\{(filterMatchQuery|filter:.,title|(variant:"viola",semanticColor:"textSubdued"|..:"span",variant:.{3,6}mesto,color:.{3,6}),htmlFor:"desktop.settings.downloadQuality.+?).{1,6}get\("desktop.settings.downloadQuality.title.+?(children:.{1,2}\(.,.\).+?,|\(.,.\){3,4},|,.\)}},.\(.,.\)\),)//'
HIDE_DL_ICON=' .BKsbV2Xl786X9a09XROH {display:none}'
HIDE_DL_MENU=' button.wC9sIed7pfp47wZbmU6m.pzkhLqffqF_4hucrVVQA {display:none}'
HIDE_VERY_HIGH=' #desktop\.settings\.streamingQuality>option:nth-child(5) {display:none}'

HIDE_PODCASTS='s|withQueryParameters\(.\)\{return this.queryParameters=.,this}|withQueryParameters(e){return this.queryParameters=(e.types?{...e, types: e.types.split(",").filter(_ => !["episode","show"].includes(_)).join(",")}:e),this}|'
HIDE_PODCASTS2='s/(!Array.isArray\(.\)\|\|.===..length\)return null;)/$1 for (let i = 0; i < (e.children ? e.children.length : e.length); i++) {const key = (e.children?.[i]?.key || e[i])?.key; if (!key || key.includes('\''episode'\'') || key.includes('\''show'\'')) { return null;}};/'

LOG_1='s|sp://logging/v3/\w+||g'
LOG_SENTRY='s|this\.getStackTop\(\)\.client=e|return;$&|'

CONNECT_OLD_1='s| connect-device-list-item--disabled||' # 1.1.70.610+
CONNECT_OLD_2='s|connect-picker.unavailable-to-control|spotify-connect|' # 1.1.70.610+
CONNECT_OLD_3='s|(className:.,disabled:)(..)|$1false|' # 1.1.70.610+
CONNECT_NEW='s/return (..isDisabled)(\?(..createElement|\(.{1,10}\))\(..,)/return false$2/' # 1.1.91.824+
DEVICE_PICKER_NEW='s|Enable showing a new and improved device picker UI",default:\K!1|true|' # 1.1.90.855 - 1.1.95.893
#DEVICE_PICKER_OLD='s|Enable showing a new and improved device picker UI",default:\K!0|false|' # 1.1.96.783 - 1.1.97.962

BETAMAX_FILTER_NEGATIVE_DURATION='s|for duration that is negative",default:\K!.(?=})|false|s'
ENABLE_CONNECT_ESPERANTO_STATE='s|Enable retrieving connect state from Esperanto instead of Cosmos",default:\K!.(?=})|false|s'
ENABLE_ESPERANTO_MIGRATION='s|Enable esperanto Migration for Ad Formats",default:\K!.(?=})|false|s'
ENABLE_HPTO_LOCATION_REFACTOR='s|Enable new permanent location for HPTO iframe to HptoHtml.js",default:\K!.(?=})|false|s'
ENABLE_USER_FRAUD_VERIFICATION='s|Enable user fraud verification",default:\K!.(?=})|false|s'
ENABLE_USER_FRAUD_VERIFICATION_REQUEST='s|Enable the IAV component make api requests",default:\K!.(?=})|false|s'
HPTO_ENABLED='s|hptoEnabled:!\K0|1|s'
HPTO_SHOWN='s|isHptoShown:!\K0|1|gs'

UPDATE_BLOCK='s|\x00\x77\x67\x3A\x2F\x2F\x64|\x00\x00\x67\x3A\x2F\x2F\x64|'

echo -e "Latest supported version: ${SXB_VERSION}"
if [[ "${NOTINSTALLED_VAR}" == 'true' ]];then
	echo -e "Detected Spotify version: ${RED}N/A${CLEAR}\n"
elif [[ $(ver "${CLIENT_VERSION}") -le $(ver "${SXB_VERSION}") ]]; then
	echo -e "Detected Spotify version: ${GREEN}${CLIENT_VERSION}${CLEAR}\n"
elif [[ $(ver "${CLIENT_VERSION}") -gt $(ver "${SXB_VERSION}") ]]; then
	echo -e "Detected Spotify version: ${RED}${CLIENT_VERSION}${CLEAR}\n"
fi
[[ $(ver "${SXB_VERSION}") -gt $(ver "1.1.0.0") && $(ver "${SXB_VERSION}") -lt $(ver "${SXB_LIVE}") ]] && echo -e "${VERSION_CK3}"

if [[ "${UNINSTALL_FLAG}" == "true" ]]; then
  if [[ ! -f "${XPUI_BAK}" ]]; then
    echo -e "${RED}Error:${CLEAR} No backup found. Exiting...\n"; exit
  else
    rm "${XPUI_SPA}" 2>/dev/null
    mv "${XPUI_BAK}" "${XPUI_SPA}"
    rm "${APP_BINARY}" 2>/dev/null
    mv "${APP_BAK}" "${APP_BINARY}"
    if [[ "${PLATFORM_TYPE}" == "macOS" ]]; then
			codesign -f -s - --deep "${APP_PATH}" 2>/dev/null
		fi
    perl -e 'print "\xE2\x9C\x94\x20\x46\x69\x6E\x69\x73\x68\x65\x64\x20\x75\x6E\x69\x6E\x73\x74\x61\x6C\x6C\n"'
		exit
	fi
fi

read_yn () {
	while : ; do
		read -p "$*" yn
		case "$yn" in
			[Yy]* ) return 0 ;;
			[Nn]* ) return 1 ;;
					* ) echo "Please answer yes or no.";;
		esac
	done
}

if [[ "${INTERACTIVE_FLAG}" == "true" ]]; then
  perl -e 'print "\xE2\x9C\x94\x20\x53\x74\x61\x72\x74\x65\x64\x20\x69\x6E\x74\x65\x72\x61\x63\x74\x69\x76\x65\x20\x6D\x6F\x64\x65\x20\x5B\x65\x6E\x74\x65\x72\x20\x79\x2F\x6E\x5D\n"';
  if [[ "${PLATFORM_TYPE}" == "macOS" ]]; then
		if read_yn "Download & install Spotify ${SXB_VERSION}? " ; then
    	INSTALLCLIENT_OPT='true';
		else
			INSTALLCLIENT_OPT='false';
		fi
	fi
	if read_yn "Enable experimental features? " ; then
		EXCLUDE_EXPERIMENTAL_FLAG='true';
	else
		EXCLUDE_EXPERIMENTAL_FLAG='false';
	fi
	if read_yn "Enable new home screen UI? " ; then
		OLD_UI_FLAG='true';
	else
		OLD_UI_FLAG='false';
	fi
	if read_yn "Remove non-music categories on home screen? " ; then
		REMOVE_PODCASTS_FLAG='true';
	else
		REMOVE_PODCASTS_FLAG='false';
	fi
  while true; do
    read -p "Remove non-music categories on home screen? " yn
    case "$yn" in
      [Yy]* ) REMOVE_PODCASTS_FLAG='true'; break ;;
      [Nn]* ) REMOVE_PODCASTS_FLAG='false'; break ;;
          * ) echo "Please answer yes or no.";;
    esac
  done
  if [[ "${PLATFORM_TYPE}" == "macOS" ]]; then
    while true; do
      read -p "Block Spotify updates? " yn
      case "$yn" in
        [Yy]* ) UPDATE_FLAG='true'; break ;;
        [Nn]* ) UPDATE_FLAG='false'; break ;;
            * ) echo "Please answer yes or no.";;
      esac
		done
	fi
	echo
fi

if [[ "${PLATFORM_TYPE}" == "macOS" ]]; then
  if [[ "${INSTALLCLIENT_OPT}" == "true" ]]; then
    curl -f -I -s -o /dev/null "$GRAB2" || { echo -e "\n${RED}Error:${CLEAR} Client download failed. Exiting...\n"; exit 1; }
    curl --progress-bar -f -o "${HOME}/Downloads/spotify-$SXB_VERSION" "$GRAB2" || { echo -e "\n${RED}Error:${CLEAR} Client download failed. Exiting...\n"; exit 1; }
    perl -e 'print "\xE2\x9C\x94\x20\x44\x6F\x77\x6E\x6C\x6F\x61\x64\x65\x64\x20\x61\x6E\x64\x20\x69\x6E\x73\x74\x61\x6C\x6C\x69\x6E\x67\x20\x53\x70\x6F\x74\x69\x66\x79\n"'
    rm -rf "${APP_PATH}" 2>/dev/null
    mkdir "${APP_PATH}"
    tar -xpjf ~/Downloads/spotify-$SXB_VERSION -C "${APP_PATH}" || { echo -e "\n${RED}Error:${CLEAR} Client install failed. Exiting...\n"; rm "${HOME}/Downloads/spotify-$SXB_VERSION" 2>/dev/null; exit 1; }
    perl -e 'print "\xE2\x9C\x94\x20\x49\x6E\x73\x74\x61\x6C\x6C\x65\x64\x20\x69\x6E\x20' "${INSTALL_PATH}" '\n"'
    rm "${HOME}/Downloads/spotify-$SXB_VERSION"
    CLIENT_VERSION="${SXB_VERSION}"
  else
    if [[ "${NOTINSTALLED_VAR}" == "true" ]]; then
			echo -e "${RED}Error:${CLEAR} Spotify not found. Exiting...\n"
			exit
		fi
	fi
fi

if [[ ! -f "${XPUI_SPA}" ]]; then
  echo -e "\n${RED}Error:${CLEAR} Detected a modified Spotify installation!\nReinstall Spotify then try again. Exiting...\n"; exit
else
  if [[ ! -w "${XPUI_PATH}" ]]; then
    echo -e "\n${YELLOW}Warning:${CLEAR} SpotX does not have write permission in Spotify directory.\nRequesting sudo permission...\n"
    sudo chmod a+wr "${INSTALL_PATH}" && sudo chmod a+wr -R "${XPUI_PATH}"
    if [[ ! -w "${XPUI_PATH}" ]]; then echo -e "\n${RED}Error:${CLEAR} SpotX was not given sudo permission. Exiting...\n"
			exit
		fi
	fi
  if [[ "${FORCE_SPOTX_FLAG}" == "false" ]]; then
    if [[ -f "${XPUI_BAK}" ]] || [[ -f "${APP_BAK}" ]]; then
      perl -e 'print "\xE2\x9C\x94\x20\x44\x65\x74\x65\x63\x74\x65\x64\x20\x62\x61\x63\x6B\x75\x70\n"'
      echo -e "${YELLOW}Warning:${CLEAR} SpotX has already been installed."
      echo -e "Use the '-f' flag to force SpotX to run.\n"
      XPUI_SKIP="true"
    else
      cp "${XPUI_SPA}" "${XPUI_BAK}"
      cp "${APP_BINARY}" "${APP_BAK}"
      XPUI_SKIP="false"
      perl -e 'print "\xE2\x9C\x94\x20\x43\x72\x65\x61\x74\x65\x64\x20\x62\x61\x63\x6B\x75\x70\n"'
		fi
  else
    if [[ -f "${XPUI_BAK}" ]]; then
      rm "${XPUI_SPA}"
      cp "${XPUI_BAK}" "${XPUI_SPA}"
      rm "${APP_BINARY}" 2>/dev/null
      cp "${APP_BAK}" "${APP_BINARY}"
      XPUI_SKIP="false"
      perl -e 'print "\xE2\x9C\x94\x20\x44\x65\x74\x65\x63\x74\x65\x64\x20\x26\x20\x72\x65\x73\x74\x6F\x72\x65\x64\x20\x62\x61\x63\x6B\x75\x70\n"'
    else
      cp "${XPUI_SPA}" "${XPUI_BAK}"
      cp "${APP_BINARY}" "${APP_BAK}"
      XPUI_SKIP="false"
      perl -e 'print "\xE2\x9C\x94\x20\x43\x72\x65\x61\x74\x65\x64\x20\x62\x61\x63\x6B\x75\x70\n"'
		fi
	fi
fi

if [[ "${XPUI_SKIP}" == "false" ]]; then
  unzip -qq "${XPUI_SPA}" -d "${XPUI_DIR}"
  if grep -Fq "SpotX" "${XPUI_JS}"; then
    echo -e "\n${YELLOW}Warning:${CLEAR} Detected SpotX but no backup file! Reinstall Spotify.\n"
    XPUI_SKIP="true"
    rm "${XPUI_BAK}" 2>/dev/null
    rm -rf "${XPUI_DIR}" 2>/dev/null
  else
    rm "${XPUI_SPA}"
	fi
  if [[ "${PREMIUM_FLAG}" == "false" ]]; then
    $PERL "${AD_ADS}" "${XPUI_JS}"
    $PERL "${AD_ADS}" "${APP_BINARY}"
    $PERL "${AD_AUDIO_ADS}" "${XPUI_JS}"
    $PERL "${AD_BILLBOARD}" "${XPUI_JS}"
    $PERL "${AD_EMPTY_AD_BLOCK}" "${XPUI_JS}"
    $PERL "${AD_LOGIC}" "${APP_BINARY}"
    $PERL "${AD_PLAYLIST_SPONSORS}" "${XPUI_JS}"
    $PERL "${AD_SLOT}" "${APP_BINARY}"
    $PERL "${AD_UPGRADE_BUTTON}" "${XPUI_JS}"
    $PERL "${AD_UPSELL}" "${XPUI_JS}"
    $PERL "${BETAMAX_FILTER_NEGATIVE_DURATION}" "${XPUI_JS}"
    $PERL "${ENABLE_CONNECT_ESPERANTO_STATE}" "${XPUI_JS}"
    $PERL "${ENABLE_ESPERANTO_MIGRATION}" "${XPUI_JS}"
    $PERL "${ENABLE_HPTO_LOCATION_REFACTOR}" "${XPUI_JS}"
    $PERL "${HIDE_DL_QUALITY}" "${XPUI_JS}"
    $PERL "${HPTO_ENABLED}" "${XPUI_JS}"
    $PERL "${HPTO_SHOWN}" "${HOME_HPTO_JS}"
    printf '%s\n%s\n%s' "${HIDE_DL_ICON}" "${HIDE_DL_MENU}" "${HIDE_VERY_HIGH}"  >> "${XPUI_CSS}"
    if [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.70.610") && $(ver "${CLIENT_VERSION}") -lt $(ver "1.1.91.824") ]]; then
      $PERL "${CONNECT_OLD_1}" "${XPUI_JS}"
      $PERL "${CONNECT_OLD_2}" "${XPUI_JS}"
      $PERL "${CONNECT_OLD_3}" "${XPUI_JS}"
    elif [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.91.824") && $(ver "${CLIENT_VERSION}") -lt $(ver "1.1.96.783") ]]; then
      $PERL "${DEVICE_PICKER_NEW}" "${XPUI_JS}"
      $PERL "${CONNECT_NEW}" "${XPUI_JS}"
    elif [[ $(ver "${CLIENT_VERSION}") -gt $(ver "1.1.96.783") ]]; then
      $PERL "${CONNECT_NEW}" "${XPUI_JS}"
		fi
    perl -e 'print "\xE2\x9C\x94\x20\x42\x6C\x6F\x63\x6B\x65\x64\x20\x61\x75\x64\x69\x6F\x2C\x20\x62\x61\x6E\x6E\x65\x72\x20\x26\x20\x76\x69\x64\x65\x6F\x20\x61\x64\x73\n"'
  else
    perl -e 'print "\xE2\x9C\x94\x20\x44\x65\x74\x65\x63\x74\x65\x64\x20\x70\x72\x65\x6D\x69\x75\x6D\x2D\x74\x69\x65\x72\x20\x70\x6C\x61\x6E\n"'
    $PERL "${AD_SLOT}" "${APP_BINARY}"
    perl -e 'print "\xE2\x9C\x94\x20\x42\x6C\x6F\x63\x6B\x65\x64\x20\x70\x6F\x64\x63\x61\x73\x74\x20\x61\x64\x73\n"'
	fi
  if [[ "${EXCLUDE_EXPERIMENTAL_FLAG}" == "true" ]]; then
    perl -e 'print "\xE2\x9C\x94\x20\x53\x6B\x69\x70\x70\x65\x64\x20\x65\x78\x70\x65\x72\x69\x6D\x65\x6E\x74\x61\x6C\x20\x66\x65\x61\x74\x75\x72\x65\x73\n"'
  else
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.2.6.861") ]] && $PERL "${ENABLE_ADD_PLAYLIST}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.99.871") ]] && $PERL "${ENABLE_ATTACK_ON_TITAN_EASTER_EGG}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.74.631") ]] && $PERL "${ENABLE_AUDIOBOOKS_CLIENTX}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.99.871") ]] && $PERL "${ENABLE_BAD_BUNNY}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.99.871") ]] && $PERL "${ENABLE_BLACK_PANTHER}" "${XPUI_JS}" #ck ver
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.89.854") ]] && $PERL "${ENABLE_BALLOONS}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.70.610") ]] && $PERL "${ENABLE_BLOCK_USERS}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.93.896") ]] && $PERL "${ENABLE_CAROUSELS}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.92.644") && $(ver "${CLIENT_VERSION}") -lt $(ver "1.1.99.871") ]] && $PERL "${ENABLE_CLEAR_DOWNLOADS}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.2.7.1264") ]] && $PERL "${ENABLE_CONCERTS_INTERESTED}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.2.7.1264") ]] && $PERL "${ENABLE_CULTURAL_MOMENTS}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.99.871") && $(ver "${CLIENT_VERSION}") -lt $(ver "1.2.6.861") ]] && $PERL "${ENABLE_DEVICE_LIST_LOCAL}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.79.763") ]] && $PERL "${ENABLE_DISCOG_SHELF}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.84.716") ]] && $PERL "${ENABLE_ENHANCE_PLAYLIST}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.86.857") ]] && $PERL "${ENABLE_ENHANCE_SONGS}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.88.595") ]] && $PERL "${ENABLE_EQUALIZER}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.2.1.958") ]] && $PERL "${ENABLE_FOLLOWERS_ON_PROFILE}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.2.0.1155") && $(ver "${CLIENT_VERSION}") -lt $(ver "1.2.6.861") ]] && $PERL "${ENABLE_FORGET_DEVICES}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.2.0.1155") ]] && $PERL "${ENABLE_HIFI}" "${XPUI_JS}" #ck ver
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.87.612") ]] && $PERL "${ENABLE_IGNORE_REC}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.87.612") ]] && $PERL "${ENABLE_INLINE_CURATION}" "${XPUI_JS}" #ck ver
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.87.612") ]] && $PERL "${ENABLE_JUST_PRESS_PLAY}" "${XPUI_JS}" #ck ver
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.70.610") ]] && $PERL "${ENABLE_LIKED_SONGS}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.70.610") && $(ver "${CLIENT_VERSION}") -lt $(ver "1.1.94.864") ]] && $PERL "${ENABLE_LYRICS_CHECK}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.87.612") ]] && $PERL "${ENABLE_LYRICS_MATCH}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.84.716") && $(ver "${CLIENT_VERSION}") -lt $(ver "1.1.87.612") ]] && $PERL "${ENABLE_LYRICS_NEW}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.87.612") ]] && $PERL "${ENABLE_NEW_EPISODES}" "${XPUI_JS}" #ck ver
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.99.871") ]] && $PERL "${ENABLE_NEXT_BEST_EPISODE}" "${XPUI_JS}" #confirm versions supported
    [[ "${DISABLEMADEFORYOU_OPT}" == "false" && $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.70.610") && $(ver "${CLIENT_VERSION}") -lt $(ver "1.1.96.783") ]] && $PERL "${ENABLE_MADE_FOR_YOU}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.91.824") ]] && $PERL "${ENABLE_PATHFINDER_DATA}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.87.612") ]] && $PERL "${ENABLE_PICK_AND_SHUFFLE}" "${XPUI_JS}" #ck ver
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.87.612") ]] && $PERL "${ENABLE_PLAY_AT_FIRST_TAP}" "${XPUI_JS}" #ck ver
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.70.610") && $(ver "${CLIENT_VERSION}") -lt $(ver "1.1.94.864") ]] && $PERL "${ENABLE_PLAYLIST_CREATION_FLOW}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.75.572") ]] && $PERL "${ENABLE_PLAYLIST_PERMISSIONS_FLOWS}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.2.0.1165") ]] && $PERL "${ENABLE_PODCAST_PLAYBACK_SPEED}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.99.871") ]] && $PERL "${ENABLE_PODCAST_TRIMMING}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.87.612") ]] && $PERL "${ENABLE_PODCAST_TRANSCRIPTIONS}" "${XPUI_JS}" #ck ver
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.86.857") && $(ver "${CLIENT_VERSION}") -lt $(ver "1.1.94.864") ]] && $PERL "${ENABLE_SEARCH_BOX}" "${XPUI_JS}"
    [[ "${DISABLESEARCHV3_OPT}" == "false" && $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.87.612") ]] && $PERL "${ENABLE_SEARCH_V3}" "${XPUI_JS}" #ck ver
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.87.612") ]] && $PERL "${ENABLE_SHOW_WRAPPED_BANNER}" "${XPUI_JS}" #ck ver
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.85.884") ]] && $PERL "${ENABLE_SIMILAR_PLAYLIST}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.87.612") ]] && $PERL "${ENABLE_SING_ALONG}" "${XPUI_JS}" #ck ver
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.99.871") ]] && $PERL "${ENABLE_STRANGER_THINGS}" "${XPUI_JS}" #ck ver
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.87.612") ]] && $PERL "${ENABLE_SUBTITLES_AUTOGENERATED_LABEL}" "${XPUI_JS}" #ck ver
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.87.612") ]] && $PERL "${ENABLE_USER_PROFILE_EDIT}" "${XPUI_JS}" #confirm versions supported
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.2.9.739") ]] && $PERL "${ENABLE_YLX_Typeahead_Search}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.2.5.954") ]] && $PERL "${ENABLE_YOUR_DJ}" "${XPUI_JS}"
    perl -e 'print "\xE2\x9C\x94\x20\x45\x6E\x61\x62\x6C\x65\x64\x20\x65\x78\x70\x65\x72\x69\x6D\x65\x6E\x74\x61\x6C\x20\x66\x65\x61\x74\x75\x72\x65\x73\n"'
	fi
  if [[ "${OLD_UI_FLAG}" == "false" && $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.93.896") && "${EXCLUDE_EXPERIMENTAL_FLAG}" == "false" ]]; then
    [[ $(ver "${CLIENT_VERSION}") -gt $(ver "1.1.93.896") && $(ver "${CLIENT_VERSION}") -lt $(ver "1.1.97.956") ]] && $PERL "${NEW_UI}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.97.956") && $(ver "${CLIENT_VERSION}") -lt $(ver "1.2.3.1107") ]] && $PERL "${NEW_UI_2}" "${XPUI_JS}"
    if [[ "${DISABLELEFTSIDEBAR_OPT}" == "true" ]]; then
			perl -e 'print "\xE2\x9C\x94\x20\x44\x69\x73\x61\x62\x6C\x65\x64\x20\x6C\x65\x66\x74\x20\x73\x69\x64\x65\x62\x61\x72\n"'
		elif [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.97.962") ]]; then
			$PERL "${ENABLE_LEFT_SIDEBAR}" "${XPUI_JS}"
		fi
    if [[ "${DISABLERIGHTSIDEBAR_OPT}" == "true" ]]; then
			perl -e 'print "\xE2\x9C\x94\x20\x44\x69\x73\x61\x62\x6C\x65\x64\x20\x72\x69\x67\x68\x74\x20\x73\x69\x64\x65\x62\x61\x72\n"'
		elif [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.98.683") ]]; then
			$PERL "${ENABLE_RIGHT_SIDEBAR}" "${XPUI_JS}";
			if [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.2.7.1264") ]]; then
				$PERL "${ENABLE_RIGHT_SIDEBAR_CREDITS}" "${XPUI_JS}"
				$PERL "${ENABLE_RIGHT_SIDEBAR_MERCH_FALLBACK}" "${XPUI_JS}"
				$PERL "${ENABLE_RIGHT_SIDEBAR_TRANSITION_ANIMATIONS}" "${XPUI_JS}"
			fi
		fi
    if [[ "${DISABLESIDEBARCOLORS_OPT}" == "true" ]]; then
			perl -e 'print "\xE2\x9C\x94\x20\x44\x69\x73\x61\x62\x6C\x65\x64\x20\x73\x69\x64\x65\x62\x61\x72\x20\x63\x6F\x6C\x6F\x72\x73\n"'
		elif [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.2.0.1165") ]]; then
				$PERL "${ENABLE_RIGHT_SIDEBAR_COLORS}" "${XPUI_JS}"
		fi
    if [[ "${DISABLESIDEBARLYRICS_OPT}" == "true" ]]; then
			perl -e 'print "\xE2\x9C\x94\x20\x44\x69\x73\x61\x62\x6C\x65\x64\x20\x73\x69\x64\x65\x62\x61\x72\x20\x6C\x79\x72\x69\x63\x73\n"'
		else
			[[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.2.0.1165") ]] && $PERL "${ENABLE_RIGHT_SIDEBAR_LYRICS}" "${XPUI_JS}"
    	[[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.2.7.1264") ]] &&	$PERL "${ENABLE_PANEL_SIZE_COORDINATION}" "${XPUI_JS}"
		fi
    perl -e 'print "\xE2\x9C\x94\x20\x45\x6E\x61\x62\x6C\x65\x64\x20\x6E\x65\x77\x20\x55\x49\n"'
  elif [[ "${OLD_UI_FLAG}" == "true" && $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.93.896") ]]; then
    perl -e 'print "\xE2\x9C\x94\x20\x45\x6E\x61\x62\x6C\x65\x64\x20\x6F\x6C\x64\x20\x55\x49\n"'
	fi
  if [[ "${REMOVE_PODCASTS_FLAG}" == "true" ]]; then
    [[ $(ver "${CLIENT_VERSION}") -lt $(ver "1.1.93.896") ]] && $PERL "${HIDE_PODCASTS}" "${XPUI_JS}"
    [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.1.93.896") ]] && $PERL "${HIDE_PODCASTS2}" "${XPUI_JS}"
    perl -e 'print "\xE2\x9C\x94\x20\x52\x65\x6D\x6F\x76\x65\x64\x20\x6E\x6F\x6E\x2D\x6D\x75\x73\x69\x63\x20\x63\x61\x74\x65\x67\x6F\x72\x69\x65\x73\x20\x6F\x6E\x20\x68\x6F\x6D\x65\x20\x73\x63\x72\x65\x65\x6E\n"'
	fi
  $PERL "${LOG_1}" "${XPUI_JS}"
  $PERL "${LOG_SENTRY}" "${VENDOR_XPUI_JS}"
  perl -e 'print "\xE2\x9C\x94\x20\x52\x65\x6D\x6F\x76\x65\x64\x20\x6C\x6F\x67\x67\x69\x6E\x67\n"'
  if [[ "${PLATFORM_TYPE}" == "macOS" ]]; then
    if [[ "${UPDATE_FLAG}" == "true" ]]; then
      $PERL "${UPDATE_BLOCK}" "${APP_BINARY}"
      perl -e 'print "\xE2\x9C\x94\x20\x42\x6C\x6F\x63\x6B\x65\x64\x20\x61\x75\x74\x6F\x6D\x61\x74\x69\x63\x20\x75\x70\x64\x61\x74\x65\x73\n"'
		fi
		xattr -cr "${APP_PATH}"
	fi
fi

if [[ "${CACHE_FLAG}" == "true" ]]; then
  rm -rf "${CACHE_PATH}"
  perl -e 'print "\xE2\x9C\x94\x20\x43\x6C\x65\x61\x72\x65\x64\x20\x61\x70\x70\x20\x63\x61\x63\x68\x65\n"'
fi

if [[ "${XPUI_SKIP}" == "false" ]]; then
  [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.2.3.1107") ]] && $PERL "${ENABLE_USER_FRAUD_VERIFICATION}" "${XPUI_JS}"
  [[ $(ver "${CLIENT_VERSION}") -ge $(ver "1.2.5.954") ]] && $PERL "${ENABLE_USER_FRAUD_VERIFICATION_REQUEST}" "${XPUI_JS}"
	echo -e "\n//# SpotX was here" >> "${XPUI_JS}"
  (cd "${XPUI_DIR}"; zip -qq -r ../xpui.spa .)
  rm -rf "${XPUI_DIR}"
  if [[ "${PLATFORM_TYPE}" == "macOS" ]]; then
    if [[ "${SKIPCODESIGN_OPT}" == "false" ]]; then
      codesign -f -s - --deep "${APP_PATH}" 2>/dev/null
      perl -e 'print "\xE2\x9C\x94\x20\x43\x6F\x64\x65\x73\x69\x67\x6E\x65\x64\x20\x53\x70\x6F\x74\x69\x66\x79\n"'
		fi
    xattr -cr "${APP_PATH}" 2>/dev/null
	fi
fi

perl -e 'print "\xE2\x9C\x94\x20\x46\x69\x6E\x69\x73\x68\x65\x64\n\n"'
