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
        <strong>Latest supported version:</strong> 1.3.10.2586.g81a118a22460
    </p> 
</center>

### Features:

- Block all audio, banner & video ads
- Block logging
- Enable developer mode
- Enable experimental features
- Hide audiobooks, episodes & podcasts on home screen
- Block automatic updates (macOS)
- Install latest desktop client versions on macOS 13+ and APT-based Linux distros
- Supports the x86_64 Spotify client on Linux and compatible clients on OS X/macOS 10.11+
- Older macOS releases require a compatible Spotify client installed manually; see the [version timeline](https://github.com/SpotX-Official/SpotX-Bash/wiki/Spotify-Desktop-Client-Version-Timeline).

### Usage:

> [!NOTE]
> Recommended order: **install Spotify, run SpotX-Bash, then open Spotify/sign in.**
> Repatch before opening an updated client. [Already opened Spotify?](https://github.com/SpotX-Official/SpotX-Bash/wiki/SpotX%E2%80%90Bash-FAQ#how-do-i-use-it)

Choose the command for your Spotify installation.

| Installation | How to run SpotX-Bash |
| --- | --- |
| macOS app, native Linux package, or Flatpak | Use the main script below. |
| Snap | Use `bash spotx-snap.sh` from the cloned repo. See [Snap / Nix](#snap--nix). |
| Nix on x86_64 Linux or Apple Silicon macOS | Follow the [SpotX-Nix instructions](https://github.com/SpotX-Official/SpotX-Nix). |

- Run the main script in your terminal:
```
bash <(curl -sSL https://spotx-official.github.io/run.sh)
```
or
```
bash <(curl -sSL https://raw.githubusercontent.com/SpotX-Official/SpotX-Bash/main/spotx.sh)
```
- If your shell does not support process substitution, use:
```
curl -sSL https://spotx-official.github.io/run.sh | bash
```
>See the [FAQ](https://github.com/SpotX-Official/SpotX-Bash/wiki/SpotX%E2%80%90Bash-FAQ#why-does-the-recommended-command-fail-in-my-shell) for more information about shell compatibility and using options with the pipe command

- By default...
  - all supported experimental features are enabled
  - free-tier user patches are applied; paid-premium users should use the  `-p` / `--premium` flag
  - macOS client auto-updates are NOT disabled; blocking them with the `-B` / `--blockupdates` flag is recommended
- On Linux, controlling client updates through your package manager or installation method is recommended so Spotify can be repatched before opening the updated client
- View additional flags/options and examples in the `Options` section below
- For more information, see the [FAQ](https://github.com/SpotX-Official/SpotX-Bash/wiki/SpotX%E2%80%90Bash-FAQ)

### Snap / Nix:

Spotify installations using Snap require the included `spotx-snap.sh` helper. Download the repo so `spotx-snap.sh` and `spotx.sh` remain in the same directory:
```
git clone https://github.com/SpotX-Official/SpotX-Bash.git
cd SpotX-Bash
bash spotx-snap.sh
```
The locally installed Snap stops receiving automatic Store updates. Run `bash spotx-snap.sh --download` to fetch and apply a fresh Store build, or `bash spotx-snap.sh --restore` to return to the official stable channel and automatic updates.
Run `bash spotx-snap.sh --help` for additional Snap options or see the [FAQ](https://github.com/SpotX-Official/SpotX-Bash/wiki/SpotX%E2%80%90Bash-FAQ#is-the-snap-version-of-spotify-supported).

Nix users on x86_64 Linux or Apple Silicon macOS should use [SpotX-Nix](https://github.com/SpotX-Official/SpotX-Nix), which applies SpotX-Bash while building the Spotify package without modifying the Nix store. It supports NixOS, nix-darwin, Home Manager, and configurations with or without flakes. Intel macOS users should continue using regular SpotX-Bash.

### Options:
<details>
  <summary>Click to expand!</summary>

| Option | Description |  
| --- | --- |  
| `-B` | block client auto-updates [macOS] |  
| `-c` | clear client app cache |  
| `-d` | enable [developer mode](https://github.com/SpotX-Official/SpotX-Bash/wiki/SpotX%E2%80%90Bash-FAQ#what-is-developer-mode) |  
| `-e` | exclude all experimental features |  
| `-f` | force SpotX-Bash to run |  
| `-h` | hide non-music on home screen |  
| `--help` | print options |  
| `-i` | enable interactive mode | 
| `--installdeb` | install latest client deb pkg on APT-based distros [Linux] |   
| `--installmac` | install latest supported client [macOS] |  
| `-l` | [set lyrics background color to black](https://github.com/SpotX-Official/SpotX-Bash/issues/20#issuecomment-1762040019) |  
| `--nocolor` | remove colors from SpotX-Bash output |  
| `--noninteractive` | skip prompts and exit with an error if required sudo authorization is unavailable |
| `-o` | use [old home screen UI](https://github.com/SpotX-Official/SpotX-Bash/wiki/SpotX%E2%80%90Bash-FAQ#what-is-the-old-ui-option) on Spotify 1.1.93.896 through 1.2.13.661 |
| `-p` | [paid premium-tier subscriber](https://github.com/SpotX-Official/SpotX-Bash/wiki/SpotX%E2%80%90Bash-FAQ#can-i-use-spotx-bash-with-a-paid-premium-account) |
| `-P <path>` | directory containing `Spotify.app` on macOS or `Apps/xpui.spa` on Linux |
| `--rollback` | install previous supported client version [macOS] |  
| `-S` | skip [codesigning](https://github.com/SpotX-Official/SpotX-Bash/discussions/3) [macOS] | 
| `--stable` | use with '--installdeb' for stable branch [Linux] |   
| `--uninstall` | uninstall SpotX-Bash |  
| `-v` | print SpotX-Bash version |  

**Examples:**

**Run SpotX-Bash, clear app cache, enable dev mode, hide non-music categories** 
```
bash <(curl -sSL https://spotx-official.github.io/run.sh) -cdh
```
**Run interactively with an existing app in your user Applications folder (macOS)**
```bash
bash <(curl -sSL https://spotx-official.github.io/run.sh) -i -P "$HOME/Applications"
```
**Run interactively with a client installed in `/opt/spotify` (Linux)**
```bash
bash <(curl -sSL https://spotx-official.github.io/run.sh) -i -P /opt/spotify
```
**Run SpotX-Bash, set paid premium-tier subscriber** 
```
bash <(curl -sSL https://spotx-official.github.io/run.sh) -p
```
**Run SpotX-Bash, install latest testing branch client version (Linux)** 
```
bash <(curl -sSL https://spotx-official.github.io/run.sh) --installdeb
```
Add `--stable` to install the stable build. APT installs required dependencies. Optional packages recommended by Spotify, such as multimedia codecs, can be installed separately.

**Run SpotX-Bash, block auto-updates, install latest supported client version (macOS)** 
```
bash <(curl -sSL https://spotx-official.github.io/run.sh) -B --installmac
```
If your installed client is newer than the supported build, `--installmac` replaces it with the supported version.

**Install latest supported client version without interactive prompts (macOS)**
```
curl -sSL https://spotx-official.github.io/run.sh | bash -s -- --noninteractive --installmac
```
</details>

### Thanks:

- [amd64fox](https://github.com/amd64fox/) of [SpotX](https://github.com/SpotX-Official/SpotX)
