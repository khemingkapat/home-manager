{
  programs.bash = {
    enable = true;
    bashrcExtra = ''source $HOME/.config/home-manager/.bashrc'';
    initExtra = ''
      source "$(blesh-share)"/ble.sh --attach=none # does not work currently
      [[ ! ''${BLE_VERSION-} ]] || ble-attach
    '';
    profileExtra = '' source $HOME/.config/home-manager/.profile '';
    enableCompletion = true;
    shellAliases = {
      hm = "home-manager";
      ".." = "cd ..";
    };
  };
}
