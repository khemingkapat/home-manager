{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.programs.manoonchai = {
    enable = mkEnableOption "Manoonchai Thai keyboard layout";

    switchKey = mkOption {
      type = types.str;
      default = "grp:alt_shift_toggle";
      description = "Key combination to switch between layouts";
      example = "grp:win_space_toggle";
    };

    layouts = mkOption {
      type = types.listOf types.str;
      default = [
        "us"
        "manoonchai"
      ];
      description = "List of keyboard layouts to use";
    };
  };

  config = mkIf config.programs.manoonchai.enable {
    # Download Manoonchai to home directory
    home.file.".local/share/manoonchai/Manoonchai.bundle.zip".source = pkgs.fetchurl {
      url = "https://github.com/narze/manoonchai-keyboards/releases/download/v1.0.0/Manoonchai.bundle.zip";
      sha256 = "sha256-1n626k5b5cxpb7paficf4g641vg8xp1aifs9iwcbxxiblicjk8j3="; # You'll need the real hash
    };

    # Create installation script
    home.file."bin/install-manoonchai".text = ''
      #!/bin/bash
      set -e

      if [ -f /usr/share/X11/xkb/symbols/manoonchai ]; then
        echo "✓ Manoonchai already installed system-wide"
        exit 0
      fi

      echo "Installing Manoonchai keyboard layout..."
      TEMP_DIR=$(mktemp -d)
      cd "$TEMP_DIR"

      # Extract the bundle
      ${pkgs.unzip}/bin/unzip ~/.local/share/manoonchai/Manoonchai.bundle.zip

      # Install system-wide (requires one-time sudo)
      echo "Installing Manoonchai system-wide (requires sudo)..."
      sudo ${pkgs.coreutils}/bin/cp -r Manoonchai.bundle/* /usr/share/X11/xkb/
      sudo ${pkgs.dpkg}/bin/dpkg-reconfigure -f noninteractive xkb-data

      rm -rf "$TEMP_DIR"
      echo "✓ Manoonchai installed successfully! Please log out and back in."
    '';
    home.file."bin/install-manoonchai".executable = true;

    # Configure GNOME input sources
    dconf.settings = {
      "org/gnome/desktop/input-sources" = {
        sources = map (
          layout:
          lib.hm.gvariant.mkTuple [
            "xkb"
            layout
          ]
        ) config.programs.manoonchai.layouts;
        xkb-options = [ config.programs.manoonchai.switchKey ];
      };
    };

    # Show installation instructions if not installed
    home.activation.manoonchai-info = lib.hm.dag.entryAnywhere ''
      if [ ! -f /usr/share/X11/xkb/symbols/manoonchai ]; then
        echo ""
        echo "=== 🇹🇭 Manoonchai Thai Keyboard Setup ==="
        echo "Run: ~/bin/install-manoonchai"
        echo "This will install Manoonchai keyboard layout system-wide (requires sudo once)"
        echo "Switch layouts with: ${config.programs.manoonchai.switchKey}"
        echo ""
      fi
    '';
  };
}
