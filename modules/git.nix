{
  programs.git = {
    enable = true;
    userName = "khemingkapat";
    userEmail = "60930364+khemingkapat@users.noreply.github.com";
    extraConfig = {
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_ed25519.pub";
    };
  };
}
