{ config, pkgs, ... }:
{

  # Enable and configure Switcher
  dconf.settings = {
    # Enable the extension
    "org/gnome/shell" = {
      enabled-extensions = [ "switcher@landau.fi" ];
    };

    # Configure Switcher extension
    "org/gnome/shell/extensions/switcher" = {
      activate-immediately = true;
      max-width-percentage = 60;
      show-switcher = [ "<Alt>space" ]; # Use Super+Space for Switcher
      workspace-indicator = true;
    };

    # Keep Super key working for overview, but disable the app search overlay
    # This way Super key alone still opens Activities, but Super+Space uses Switcher
    "org/gnome/desktop/wm/keybindings" = {
      panel-main-menu = [ ]; # This only disables the old-style menu, not the Super key
    };
  };
}
