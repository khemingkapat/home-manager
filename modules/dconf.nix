{ config
, pkgs
, lib
, ...
}:

{
  # GNOME dconf settings
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Adwaita";
      cursor-theme = "Adwaita";
      # font-name = "Noto Sans 12";
      # document-font-name = "Noto Sans 12";
      # monospace-font-name = "JetBrainsMono Nerd Font 12";
    };

    "org/gnome/terminal/legacy/profiles:/:default" = {
      font = "JetBrainsMono Nerd Font 12";
      use-system-font = false;
      background-color = "000000";
      foreground-color = "#d4d4d4";
      use-theme-colors = false;
      audible-bell = false;
      scrollback-lines = 10000;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      ambient-enabled = false;
      idle-brightness = 100; # 0-100 scale
      power-button-action = "suspend";
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = false; # Disable dynamic workspaces
      workspaces-only-on-primary = false;
      num-workspace = 4;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      num-workspaces = 4; # Fixed number of workspaces
      titlebar-font = "Noto Sans Bold 11";
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
        "space-bar@luchrioh"

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
      gap-size = 16;
      maximized-threshold = 20;

      layout-1 = [ "" ];
      layout-2 = [ "" ];
      layout-3 = [ "" ];
      layout-4 = [ "" ];

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
      switch-to-workspace-1 = [ "<Super>x" ];
      switch-to-workspace-2 = [ "<Super>c" ];
      switch-to-workspace-3 = [ "<Super>v" ];
      switch-to-workspace-4 = [ "<Super>s" ];
      move-to-workspace-1 = [ "<Super><Shift>1" ];
      move-to-workspace-2 = [ "<Super><Shift>2" ];
      move-to-workspace-3 = [ "<Super><Shift>3" ];
      move-to-workspace-4 = [ "<Super><Shift>4" ];

      activate-window-menu = [ "" ];
      switch-input-source = [ "<Super>space" ];
      switch-input-source-backward = [ "<Super><Shift>space" ];
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

    # Disable conflicting shortcuts
    "org/gnome/shell/keybindings" = {
      # Disable built-in "switch to application"
      switch-to-application-1 = [ "" ];
      switch-to-application-2 = [ "" ];
      switch-to-application-3 = [ "" ];
      switch-to-application-4 = [ "" ];
      switch-to-application-5 = [ "" ];
      switch-to-application-6 = [ "" ];
      switch-to-application-7 = [ "" ];
      switch-to-application-8 = [ "" ];
      switch-to-application-9 = [ "" ];
    };

    # Disable Dash to Dock shortcuts if present
    "org/gnome/shell/extensions/dash-to-dock" = {
      hot-keys = false; # This disables Super+num for dock
    };

    "org/gnome/shell/extensions/space-bar" = {
      enable-activate-workspace-shortcuts = true;
      enable-move-to-workspace-shortcuts = false;
      open-menu = [ "<Shift><Super>w" ];

    };

    "org/gnome/desktop/input-sources" = {
      # Correct syntax: use lib.hm.gvariant.mkTuple for dconf tuples
      sources = [
        (lib.hm.gvariant.mkTuple [
          "xkb"
          "us"
        ]) # English US
        (lib.hm.gvariant.mkTuple [
          "xkb"
          "th"
        ]) # Thai
      ];

      # Optional: Configure switching behavior
      mru-sources = [
        (lib.hm.gvariant.mkTuple [
          "xkb"
          "us"
        ])
        (lib.hm.gvariant.mkTuple [
          "xkb"
          "th"
        ])
      ];
    };

  };
}
