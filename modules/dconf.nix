{ config, pkgs, ... }:

{
  # GNOME dconf settings
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Adwaita";
      cursor-theme = "Adwaita";
      # font-name = "Cantarell 16";
      # document-font-name = "Cantarell 16";
      # monospace-font-name = "Source Code Pro 16";
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = false; # Disable dynamic workspaces
      workspaces-only-on-primary = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      num-workspaces = 4; # Fixed number of workspaces
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
      speed = 0.0; # Neutral speed with no acceleration
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      two-finger-scrolling-enabled = true;
      tap-to-click = true;
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        "tactile@lundal.io"
        # Add other extensions here
      ];
      # favorite-apps = [
      #   "org.gnome.Nautilus.desktop"
      #   "firefox.desktop"
      #   "org.gnome.Terminal.desktop"
      #   "org.gnome.TextEditor.desktop"
      #   "org.gnome.Settings.desktop"
      # ];
    };

    "org/gnome/shell/extensions/tactile" = {
      col-0 = 2;
      col-1 = 1;
      col-2 = 1;
      col-3 = 2;
      row-0 = 1;
      row-1 = 1;
      gap-size = 32;
      maximized-threshold = 20;
    };


    # Note: Tactile extension settings might need to be configured through
    # the extension's own preferences dialog or different dconf path

    # "org/gnome/desktop/session" = {
    #   idle-delay = 900; # 15 minutes
    # };
    #
    # "org/gnome/settings-daemon/plugins/power" = {
    #   sleep-inactive-ac-timeout = 3600; # 1 hour
    #   sleep-inactive-battery-timeout = 1800; # 30 minutes
    # };

    # Additional useful GNOME settings
    "org/gnome/desktop/privacy" = {
      report-technical-problems = false;
      send-software-usage-stats = false;
    };

    # "org/gnome/desktop/search-providers" = {
    #   sort-order = [
    #     "org.gnome.Contacts.desktop"
    #     "org.gnome.Documents.desktop"
    #     "org.gnome.Nautilus.desktop"
    #   ];
    # };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
      toggle-maximized = [ "<Super>m" ];
      toggle-fullscreen = [ "<Super>f" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      move-to-workspace-1 = [ "<Super><Shift>1" ];
      move-to-workspace-2 = [ "<Super><Shift>2" ];
      move-to-workspace-3 = [ "<Super><Shift>3" ];
      move-to-workspace-4 = [ "<Super><Shift>4" ];
    };

    # Disable conflicting default GNOME keybindings
    "org/gnome/shell/keybindings" = {
      toggle-message-tray = [ ]; # Disable Super+M for message tray
      toggle-overview = [ ]; # Disable if Super+M is used for overview
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      terminal = [ "<Super>Return" ];
      home = [ "<Super>e" ];
    };

  };
}
