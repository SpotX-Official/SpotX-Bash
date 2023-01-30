  <p align="center">
  <a href="https://github.com/jetfir3/SpotX-Bash"><img src="https://raw.githubusercontent.com/jetfir3/SpotX-Bash/main/.github/Pic/banner-logo.png" />
</p>

<p align="center">        
      <a href="https://t.me/SpotxCommunity"><img src="https://raw.githubusercontent.com/amd64fox/SpotX/main/.github/Pic/Shields/SpotX_Community.svg"></a>
      </p>

 ***     

<center>
    <h4 align="center">Adblock for Spotify clients on Linux & macOS.</h4>
    <p align="center">
        <strong>Lastest supported version:</strong> 1.2.4.905
    </p> 
</center>

### Features:

- Blocks all audio, banner & video ads
- Blocks logging (Sentry, etc)
- Blocks Spotify automatic updates (optional)
- Enables [experimental features](https://github.com/SpotX-CLI/SpotX-Win/discussions/50) (optional)
- Removes audiobooks, episodes & podcasts on home screen (optional)

### Install:

- Run the following command in Terminal:
```
bash <(curl -sSL https://raw.githubusercontent.com/jetfir3/SpotX-Bash/main/spotx.sh)
```
- Default setup enables all supported experimental features and enables new UI

#### Optional Arguments:
`-c`        : clear Spotify app cache  
`-e`        : exclude all experimental features  
`-f`        : force SpotX to run  
`-h`        : print help message (also --help)  
`-i`        : enable interactive mode  
`-o`        : use old home screen UI  
`-p`        : set if paid premium-tier subscriber  
`-P [path]` : set path to Spotify  
`-r`        : remove non-music categories on home screen  
`-u`        : block Spotify updates (macOS only)  
`-U`        : uninstall SpotX  

`--disablemadeforyou`  
`--disableleftsidebar`  
`--disablerightsidebar`  
`--disablesidebarcolors`  
`--disablesidebarlyrics`  
`--installspotify` (macOS only)  

Example usage -- clearing app cache, blocking updates and disabling right sidebar colors:
```
bash <(curl -sSL https://raw.githubusercontent.com/jetfir3/SpotX-Bash/main/install.sh) -cru --disablesidebarcolors
```

### Notes:

- Supports desktop client v1.1.84.716+
- Snap installs on Linux are not supported
- SpotX-Bash must be run prior to setting up Spicetify

### Credits

- SpotX-Bash is based on [SpotX](https://github.com/amd64fox/spotx) with permission from [amd64fox](https://github.com/amd64fox/).
