  <p align="center">
  <a href="https://github.com/jetfir3/SpotX-Bash"><img src="https://raw.githubusercontent.com/jetfir3/SpotX-Bash/main/.github/images/banner-logo.png" />
</p>

<p align="center">        
      <a href="https://github.com/amd64fox/SpotX"><img src="https://raw.githubusercontent.com/jetfir3/SpotX-Bash/main/.github/images/spotx.svg"></a>
      <a href="https://t.me/SpotxCommunity"><img src="https://raw.githubusercontent.com/amd64fox/SpotX/main/.github/Pic/Shields/SpotX_Community.svg"></a>
      </p>

 ***     

<center>
    <h4 align="center">Adblock for Spotify clients on Linux & macOS</h4>
    <p align="center">
        <strong>Lastest supported version:</strong> 1.2.4.912
    </p> 
</center>

### Features:

- Blocks all audio, banner & video ads
- Blocks logging (Sentry, etc)
- Blocks Spotify automatic updates (optional)
- Enables [experimental features](https://github.com/SpotX-CLI/SpotX-Win/discussions/50) (optional)
- Removes audiobooks, episodes & podcasts on home screen (optional)

### Usage:

- Run the following command in terminal:
```
bash <(curl -sSL https://raw.githubusercontent.com/jetfir3/SpotX-Bash/main/spotx.sh)
```
- Default setup enables all supported experimental features and enables new UI

| Argument | Description |
| --- | --- |
| `-c` | Clear Spotify app cache |  
| `--disableleftsidebar` | Disable experimental left sidebar |  
| `--disablemadeforyou` | Disable 'Made for You'
| `--disablerightsidebar` | Disable experimental right sidebar |
| `--disablesidebarcolors` | Disable colors in experimental sidebar |
| `--disablesidebarlyrics` | Disable lyrics in experimental sidebar |  
| `-e` | Exclude all experimental features |  
| `-f` | Force SpotX to run | 
| `-h` | Print help message (also --help) |
| `-i` | Enable interactive mode |  
| `--installspotify` | Install latest supported Spotify (macOS only) |  
| `-o` | Use old home screen UI | 
| `-p` | Set if paid premium-tier subscriber | 
|`-P [path]` | Set path to Spotify |
|`-r` | Remove non-music categories on home screen |
|`-u` | Block Spotify updates (macOS only) |
|`-U` | Uninstall SpotX |

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
