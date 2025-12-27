# debian-dev-machine-setup | Debian 13

---

## Description

This repository contains Ansible playbooks to configure a system as a lightweight ephemeral development machine after a clean install.

The playbooks are designed for Debian-based systems with minimal modifications but have only been tested on:

- **Debian 13/Trixie (stable)**

## What Gets Installed and Configured?

Below is a summary of the packages installed and configured, organized by roles:

- **role: base**
  - Sets the default system editor to Vim instead of Nano.
  - Enables the UFW firewall.
  - Tunes system swappiness to minimize swapping.
  - Upgrades all system packages.
  - Installs archiving tools like `zip`, `rar`, and others.
  - Installs LibreOffice.
  - Installs development tools such as `httpie`, `xh`, `cargo`, `golang`, `poetry`, and more.
  - Installs download tools like `wget` and `aria2`.
  - Installs image, audio, and video tools like `vlc` and `imagemagick`.
  - Enables `fzf` fuzzy finder in the Zsh terminal; see this [YouTube video](https://www.youtube.com/watch?v=1a5NiMhqAR0) for usage instructions.
- **role: terminal_customizations**
  - Downloads and installs Nerd Fonts from [ryanoasis/nerd-fonts](https://github.com/ryanoasis/nerd-fonts), ideal for terminals and programming editors.
  - Copies and enables a sample Tilix configuration file with a configured Nerd Font.
  - Copies and enables a sample `~/.tmux.conf` file with the [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) and several Tmux plugins if one does not exist.
- **role: vim**
  - Installs Vim packages.
  - Installs the [amix/vimrc](https://github.com/amix/vimrc) Vim distribution.
  - Creates a sample Vim customization file at `~/.vim_runtime/my_configs.vim`.
    - Additional Vim settings are enabled in `~/.vim_runtime/my_configs.vim`, which are not part of the Vim distribution. Edit this file as needed.
- **role: zsh**
  - Installs the Zsh package and sets it as the user’s default shell.
  - Installs the Antigen Zsh plugin manager.
  - Copies and enables a sample `~/.zshrc` file if one does not exist, including:
    - A function to prevent `ssh-agent` from repeatedly prompting for encrypted SSH key passwords when opening new terminals.
    - Additional shell aliases, functions, and variables in `~/.shell_aliases.sh`, `~/.shell_functions.sh`, and `~/.shell_variables.sh`.
  - Installs [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh) and enables select bundled plugins.
  - Enables the Pure Zsh theme (other themes like spaceship-promopt and bullet-train can also be configured).
- **role: privacy**
  - Installs Tor.
  - Configures Tor to run at boot and excludes certain countries as exit nodes.
    - Edit `/etc/tor/torrc` as needed.
  - Installs ProxyChains.
  - Configures ProxyChains to use Tor; see [my Medium story](https://fazlearefin.medium.com/tunneling-traffic-over-tor-network-using-proxychains-34c77ec32c0f) for usage instructions.
    - Edit `/etc/proxychains4.conf` as needed.
  - Installs the Metadata Anonymization Toolkit.
- **role: security**
  - Installs ClamAV (antivirus) CLI tool.
  - Installs Firejail for sandboxing applications.

---

## Step 0 | Prerequisites for Running the Ansible Playbooks

On the system to be configured, perform the following steps.

Install `ansible` and `git` using `apt`:

```bash
sudo apt update
sudo apt full-upgrade -y
sudo apt install ansible git -y
```

Clone this repository:

```bash
git clone https://github.com/FazleArefin/debian-dev-machine-setup.git
cd debian-dev-machine-setup
```

## Step 1 | Running the Playbooks to Configure Your System

Run the following command as the primary user of the system, **not as `root`**:

```bash
ansible-playbook main.yml -vv -e "local_username=$(id -un)" -K
```

Enter the sudo password when prompted for `BECOME password:`.

The `main.yml` playbook may take 10 minutes to an hour to complete depending on your system and internet connection speed.

After completion, reboot your system to apply all changes.

---

## Known Issues

- If the Ansible playbook halts after completing some tasks, rerun it. Most tasks are idempotent, so running the playbook multiple times will not cause issues.
- If your terminal displays garbled characters due to a Zsh theme, change the terminal font to a suitable Nerd Font in the terminal settings.
- To disable fuzzy finder completions, comment out or remove the `#fzf` lines in `~/.zshrc` (this is a feature, not an issue).

---

## Pull Requests and Forks

Pull requests are welcome, but this repository is tailored to my needs. For personalization, consider forking the repository to suit your requirements.

---

## Donations

If this project saves you time and effort, feel free to make a donation. The code is completely free with *no strings attached*.

Bitcoin (BTC): `bc1qzlhpm94vtk2ht67etdutzcy2g5an5v6g36tp0m`
