# Quick Installation Guide
1. Boot up your distro of choice
2. use any default package manager to install `git` and `curl` first
3. clone this repo down to the `~/.config` folder
4. install `nix`
5. run the command `echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf` to allow home-manager to run and use flakes
6. run the command `nix run home-manager -- switch --flake .#<username>` which my username is `khemi`
