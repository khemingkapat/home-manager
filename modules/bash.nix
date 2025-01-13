{
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      source $HOME/.nix-profile/share/blesh/ble.sh --noattach 
      source $HOME/.config/home-manager/.bashrc
      [[ ! ''${BLE_VERSION-} ]] || ble-attach
    '';
    # initExtra = ''
    #   clear
    # '';
    profileExtra = '' source $HOME/.config/home-manager/.profile '';
    enableCompletion = true;
    shellAliases = {
      hm = "home-manager";
      ".." = "cd ..";
    };
  };
}
