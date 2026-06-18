{
  programs.git = {
    enable = true;
    settings = {
      user.name = "khemingkapat";
      user.email = "60930364+khemingkapat@users.noreply.github.com";
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_ed25519.pub";
    };
  };
}
