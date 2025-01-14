{
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      source $HOME/.config/home-manager/.bashrc
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
