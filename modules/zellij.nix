{
  programs.zellij = {
    enable = true;
    settings = {
      default_layout = "compact";
      pane_frames = false;
      show_startup_tips = false;
      copy_command = "wl-copy";
    };
  };
}
