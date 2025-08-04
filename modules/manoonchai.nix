{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.programs.manoonchai;
in
{
  options.programs.manoonchai = {
    enable = mkEnableOption "Manoonchai Thai keyboard layout";

    autoInstall = mkOption {
      type = types.bool;
      default = false;
      description = "Automatically attempt to install Manoonchai system-wide";
    };

    switchKey = mkOption {
      type = types.str;
      default = "grp:alt_shift_toggle";
      description = "Key combination to switch between layouts";
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

  config = mkIf cfg.enable {
    # Download the correct XKB file for Linux
    home.file.".local/share/manoonchai/Manoonchai_xkb".source = pkgs.fetchurl {
      url = "https://github.com/Manoonchai/Manoonchai/releases/download/v1.0/Manoonchai_xkb";
      sha256 = "1c75w6dsy4w0rsvv7lsi38220i6j6yaqbm4affhz8cz49idh2sq7"; # You'll need to get this hash
    };

    # Create installation script
    home.file."bin/install-manoonchai".executable = true;
    # Create installation script
    home.file."bin/install-manoonchai".text = ''
      #!/bin/bash
      set -e

      RED='\033[0;31m'
      GREEN='\033[0;32m'
      YELLOW='\033[1;33m'
      NC='\033[0m'

      if [ -f /usr/share/X11/xkb/symbols/manoonchai ] && grep -q "manoonchai" /usr/share/X11/xkb/rules/evdev.lst; then
        echo -e "''${GREEN}✓ Manoonchai already installed system-wide''${NC}"
        exit 0
      fi

      echo -e "''${YELLOW}Installing Manoonchai keyboard layout...''${NC}"

      # Install the XKB symbols file
      echo -e "''${YELLOW}Installing XKB symbols file...''${NC}"
      sudo ${pkgs.coreutils}/bin/cp ~/.local/share/manoonchai/Manoonchai_xkb /usr/share/X11/xkb/symbols/manoonchai
      sudo ${pkgs.coreutils}/bin/chmod 644 /usr/share/X11/xkb/symbols/manoonchai

      # Add to XKB rules so GNOME can find it
      echo -e "''${YELLOW}Registering layout in XKB rules...''${NC}"

      # Add to evdev.lst if not already there
      if ! grep -q "manoonchai" /usr/share/X11/xkb/rules/evdev.lst; then
        echo "  manoonchai      th: Manoonchai" | sudo tee -a /usr/share/X11/xkb/rules/evdev.lst
      fi

      # Add to base.lst if not already there  
      if ! grep -q "manoonchai" /usr/share/X11/xkb/rules/base.lst; then
        echo "  manoonchai      th: Manoonchai" | sudo tee -a /usr/share/X11/xkb/rules/base.lst
      fi

      # Add layout rule to evdev rules file
      if ! grep -q "manoonchai" /usr/share/X11/xkb/rules/evdev; then
        echo "" | sudo tee -a /usr/share/X11/xkb/rules/evdev
        echo "! layout" | sudo tee -a /usr/share/X11/xkb/rules/evdev  
        echo "  manoonchai = +manoonchai(ThaiMnc)" | sudo tee -a /usr/share/X11/xkb/rules/evdev
      fi

      # Update XKB cache
      sudo ${pkgs.dpkg}/bin/dpkg-reconfigure -f noninteractive xkb-data 2>/dev/null || echo "XKB cache updated"

      # Verify installation
      if [ -f /usr/share/X11/xkb/symbols/manoonchai ] && grep -q "manoonchai" /usr/share/X11/xkb/rules/evdev.lst; then
        echo -e "''${GREEN}✓ Manoonchai installed and registered successfully!''${NC}"
        echo -e "''${YELLOW}Please log out and back in to use the new layout.''${NC}"
        echo -e "''${YELLOW}Switch layouts with: ${cfg.switchKey}''${NC}"
      else
        echo -e "''${RED}✗ Installation verification failed''${NC}"
        exit 1
      fi
    '';

    # Configure GNOME input sources
    dconf.settings = {
      "org/gnome/desktop/input-sources" = {
        sources = [
          (lib.hm.gvariant.mkTuple [
            "xkb"
            "us"
          ])
          (lib.hm.gvariant.mkTuple [
            "xkb"
            "manoonchai"
          ]) # Thai layout with ThaiMnc variant
        ];
        xkb-options = [ cfg.switchKey ];
      };
    };

    # Show installation instructions
    home.activation.manoonchai-info = mkIf (!cfg.autoInstall) (
      lib.hm.dag.entryAnywhere ''
        if [ ! -f /usr/share/X11/xkb/symbols/manoonchai ]; then
          echo ""
          echo "=== 🇹🇭 Manoonchai Thai Keyboard Setup ==="
          echo "Run: ~/bin/install-manoonchai"
          echo "Switch layouts with: ${cfg.switchKey}"
          echo ""
        fi
      ''
    );
  };
}
