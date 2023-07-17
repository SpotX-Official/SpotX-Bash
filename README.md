  <p align="center">
  <a href="https://github.com/jetfir3/SpotX-Bash"><img src="https://raw.githubusercontent.com/jetfir3/SpotX-Bash/main/.github/images/banner-logo.png" />
</p>

<p align="center">        
      <a href="https://github.com/amd64fox/SpotX"><img src="https://raw.githubusercontent.com/jetfir3/SpotX-Bash/main/.github/images/spotx.svg"></a>
      <a href="https://t.me/SpotxCommunity"><img src="https://raw.githubusercontent.com/amd64fox/SpotX/main/.github/Pic/Shields/SpotX_Community.svg"></a>
      </p>

 ***     

<center>
    <h4 align="center">Adblock for the Spotify desktop client on Linux & macOS</h4>
    <p align="center">
        <strong>Latest supported version:</strong> 1.2.16.947.gcfbaa410
    </p> 
</center>

### Features:

- Block all audio, banner & video ads
- Block logging (Sentry, etc)
- Enable [developer mode](https://github.com/jetfir3/SpotX-Bash/wiki/SpotX%E2%80%90Bash-FAQ#what-is-developer-mode)
- Enable [experimental features](https://github.com/amd64fox/SpotX/discussions/50)
- Hide audiobooks, episodes & podcasts on home screen
- Block automatic updates (macOS)
- Install supported desktop client versions (macOS)

### Usage:

- Run the following command in terminal:
```
bash <(curl -sSL https://gist.github.com/jetfir3/e8830cf8deba6a4f15eec094d344f7b1/raw/spotx.sh)
```
- By default, all supported experimental features are enabled
- View additional arguments and examples in the `Options` section below
- See the [FAQ](https://github.com/jetfir3/SpotX-Bash/wiki/SpotX%E2%80%90Bash-FAQ) for more information

<details>
<summary><h3>Options:</h3></summary>

| Option | Description |  
| --- | --- |  
| `-B` | block Spotify auto-updates (macOS) |  
| `-c` | clear Spotify app cache |  
| `-d` | enable [developer mode](https://github.com/jetfir3/SpotX-Bash/wiki/SpotX%E2%80%90Bash-FAQ#what-is-developer-mode) |  
| `-e` | exclude all experimental features |  
| `-f` | force SpotX-Bash to run |  
| `-h` | hide non-music on home screen |  
| `--help` | print options |  
| `-i` | enable interactive mode |  
| `-I` | install latest supported client (macOS) |  
| `-o` | use [old home screen UI](https://github.com/jetfir3/SpotX-Bash/wiki/SpotX%E2%80%90Bash-FAQ#what-is-the-old-and-new-ui) |  
| `-p` | paid premium-tier subscriber |  
| `-P [path]` | set path to Spotify |  
| `-S` | skip [codesigning](https://github.com/jetfir3/SpotX-Bash/discussions/3) (macOS) |  
| `--uninstall` | uninstall SpotX-Bash |  
| `-v` | print SpotX-Bash version |  
| `-V [version]` | install client version (macOS) |  

**Examples:**

**Run SpotX-Bash, clear app cache, enable dev mode, hide non-music categories** 
```
bash <(curl -sSL https://gist.github.com/jetfir3/e8830cf8deba6a4f15eec094d344f7b1/raw/spotx.sh) -cdh
```
**Run SpotX-Bash, enable interactive mode, set custom path to Spotify** 
```
bash <(curl -sSL https://gist.github.com/jetfir3/e8830cf8deba6a4f15eec094d344f7b1/raw/spotx.sh) -i -P $HOME/Downloads/
```
**Run SpotX-Bash, set paid premium-tier subscriber** 
```
bash <(curl -sSL https://gist.github.com/jetfir3/e8830cf8deba6a4f15eec094d344f7b1/raw/spotx.sh) -p
```
**Run SpotX-Bash, block auto-updates, install latest supported client version (macOS)** 
```
bash <(curl -sSL https://gist.github.com/jetfir3/e8830cf8deba6a4f15eec094d344f7b1/raw/spotx.sh) -BI
```
</details>

### Credits

- Thanks to [amd64fox](https://github.com/amd64fox/) of [SpotX](https://github.com/amd64fox/spotx)
