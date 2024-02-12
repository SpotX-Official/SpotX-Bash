  <p align="center">
  <a href="https://github.com/jetfir3/SpotX-Bash"><img src="https://spotx-official.github.io/images/logos/logo_sxb.png" />
</p>

<p align="center">        
      <a href="https://github.com/amd64fox/SpotX"><img src="https://spotx-official.github.io/images/shields/spotx-win_sxb.svg"></a>
      <a href="https://t.me/SpotxCommunity"><img src="https://spotx-official.github.io/images/shields/SpotX_Community.svg"></a>
      </p>

 ***     

<center>
    <h4 align="center">Adblock for the Spotify desktop client on Linux & macOS</h4>
    <p align="center">
        <strong>Latest supported version:</strong> 1.2.31.1205.g4d59ad7c
    </p> 
</center>

### Features:

- Block all audio, banner & video ads
- Block logging
- Enable [developer mode](https://github.com/SpotX-Official/SpotX-Bash/wiki/SpotX%E2%80%90Bash-FAQ#what-is-developer-mode)
- Enable experimental features
- Hide audiobooks, episodes & podcasts on home screen
- Remove [lyrics background color](https://github.com/SpotX-Official/SpotX-Bash/issues/20#issuecomment-1762040019)
- Block automatic updates (macOS)
- Install supported desktop client versions (macOS)
- Install latest desktop client on APT-based distros (Linux)


### Usage:

- Run the following command in terminal:
```
bash <(curl -sSL https://spotx-official.github.io/run.sh)
```
- By default, all supported experimental features are enabled
- View additional arguments and examples in the `Options` section below
- See the [FAQ](https://github.com/SpotX-Official/SpotX-Bash/wiki/SpotX%E2%80%90Bash-FAQ) for more information

<details>
<summary><h3>Options:</h3></summary>

| Option | Description |  
| --- | --- |  
| `-B` | block Spotify auto-updates [macOS] |  
| `-c` | clear Spotify app cache |  
| `-d` | enable [developer mode](https://github.com/SpotX-Official/SpotX-Bash/wiki/SpotX%E2%80%90Bash-FAQ#what-is-developer-mode) |  
| `-e` | exclude all experimental features |  
| `-f` | force SpotX-Bash to run |  
| `-h` | hide non-music on home screen |  
| `--help` | print options |  
| `-i` | enable interactive mode | 
| `--installdeb` | install latest client deb pkg on APT-based distros [Linux] |   
| `--installmac` | install latest supported client [macOS] |  
| `-l` | [no lyrics background color](https://github.com/SpotX-Official/SpotX-Bash/issues/20#issuecomment-1762040019) |  
| `-o` | use [old home screen UI](https://github.com/SpotX-Official/SpotX-Bash/wiki/SpotX%E2%80%90Bash-FAQ#what-is-the-old-and-new-ui) |  
| `-p` | [paid premium-tier subscriber](https://github.com/SpotX-Official/SpotX-Bash/wiki/SpotX%E2%80%90Bash-FAQ#can-spotx-bash-be-used-with-a-paid-premium-account) |  
| `-P <path>` | set path to Spotify |  
| `-S` | skip [codesigning](https://github.com/SpotX-Official/SpotX-Bash/discussions/3) [macOS] | 
| `--stable` | use with '--installdeb' for stable branch [Linux] |   
| `--uninstall` | uninstall SpotX-Bash |  
| `-v` | print SpotX-Bash version |  
| `-V <version>` | install client version [macOS] |  

**Examples:**

**Run SpotX-Bash, clear app cache, enable dev mode, hide non-music categories** 
```
bash <(curl -sSL https://spotx-official.github.io/run.sh) -cdh
```
**Run SpotX-Bash, enable interactive mode, set custom path to Spotify** 
```
bash <(curl -sSL https://spotx-official.github.io/run.sh) -i -P $HOME/Downloads/
```
**Run SpotX-Bash, set paid premium-tier subscriber** 
```
bash <(curl -sSL https://spotx-official.github.io/run.sh) -p
```
**Run SpotX-Bash, install latest testing branch client version (Linux)** 
```
bash <(curl -sSL https://spotx-official.github.io/run.sh) --installdeb
```
**Run SpotX-Bash, block auto-updates, install latest supported client version (macOS)** 
```
bash <(curl -sSL https://spotx-official.github.io/run.sh) -B --installmac
```
</details>

### Thanks:

- [amd64fox](https://github.com/amd64fox/) of [SpotX](https://github.com/SpotX-Official/SpotX)
