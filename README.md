  <p align="center">
  <a href="https://github.com/jetfir3/SpotX-Bash"><img src="https://raw.githubusercontent.com/jetfir3/SpotX-Bash/main/.github/images/banner-logo.png" />
</p>

<p align="center">        
      <a href="https://github.com/amd64fox/SpotX"><img src="https://raw.githubusercontent.com/jetfir3/SpotX-Bash/main/.github/images/spotx.svg"></a>
      <a href="https://t.me/SpotxCommunity"><img src="https://raw.githubusercontent.com/amd64fox/SpotX/main/.github/Pic/Shields/SpotX_Community.svg"></a>
      </p>

 ***     

<center>
    <h4 align="center">Adblock for Spotify on Linux & macOS</h4>
    <p align="center">
        <strong>Lastest supported version:</strong> 1.2.9.743
    </p> 
</center>

### Features:

- Blocks all audio, banner & video ads
- Blocks logging (Sentry, etc)
- Blocks automatic updates (optional)
- Enables [experimental features](https://github.com/amd64fox/SpotX/discussions/50) (optional)
- Removes audiobooks, episodes & podcasts on home screen (optional)

### Usage:

- Run the following command in terminal:
```
bash <(curl -sSL https://gist.github.com/jetfir3/e8830cf8deba6a4f15eec094d344f7b1/raw/spotx.sh)
```
- Default setup enables all supported experimental features and enables new UI
- Additional arguments can be used to customize some features:

| Argument | Description |
| --- | --- |
| `-c` | Clear client app cache |  
| `--disableleftsidebar` | Disable experimental left sidebar |  
| `--disablemadeforyou` | Disable 'Made for You'
| `--disablerightsidebar` | Disable experimental right sidebar |
| `--disablesidebarcolors` | Disable colors in experimental sidebar |
| `--disablesidebarlyrics` | Disable lyrics in experimental sidebar |  
| `-e` | Exclude all experimental features |  
| `-f` | Force SpotX to run | 
| `-h` | Print help message (also --help) |
| `-i` | Enable interactive mode |  
| `--installclient` | Install latest supported client version (macOS only) |  
| `-o` | Use old home screen UI | 
| `-p` | Set if paid premium-tier subscriber | 
| `-P [path]` | Set path to client app |
| `-r` | Remove non-music categories on home screen |
| `--skipcodesign` | Skip [codesigning](https://github.com/jetfir3/SpotX-Bash/discussions/3) (macOS only) |
| `-u` | Block client updates (macOS only) |
| `-U` | Uninstall SpotX |
| `-v` | Print version (also --version) |

- Example usage with arguments:  
```
bash <(curl -sSL https://gist.github.com/jetfir3/e8830cf8deba6a4f15eec094d344f7b1/raw/spotx.sh) -cru --disablesidebarcolors
```

### Notes:

- Supports desktop client v1.1.84.716+
- View the [FAQ](https://github.com/jetfir3/SpotX-Bash/wiki/SpotX%E2%80%90Bash-FAQ) for additional information

### Credits

- Thanks to [amd64fox](https://github.com/amd64fox/) of [SpotX](https://github.com/amd64fox/spotx).
