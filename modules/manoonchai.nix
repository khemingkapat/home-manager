{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Download Manoonchai layout file
  home.file.".local/share/xkb/symbols/manoonchai".source = pkgs.fetchurl {
    url = "https://github.com/Manoonchai/Manoonchai/releases/download/v1.0/Manoonchai_xkb";
    sha256 = "1c75w6dsy4w0rsvv7lsi38220i6j6yaqbm4affhz8cz49idh2sq7";
  };

  # Auto-enable Manoonchai on every login
  home.file.".config/autostart/manoonchai.desktop" = {
    text = ''
      [Desktop Entry]
      Type=Application
      Name=Manoonchai Auto-Enable
      Exec=${pkgs.bash}/bin/bash -c "setxkbmap -I ~/.local/share/xkb -layout 'us,manoonchai' -option 'grp:win_space_toggle'"
      Hidden=false
      NoDisplay=true
      X-GNOME-Autostart-enabled=true
      Comment=Auto-enable Manoonchai Thai keyboard with Win+Space toggle
    '';
  };

  # GNOME integration
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      sources = [
        (lib.hm.gvariant.mkTuple [
          "xkb"
          "us"
        ])
        (lib.hm.gvariant.mkTuple [
          "xkb"
          "manoonchai(ThaiMnc)"
        ])
      ];
      xkb-options = [ "grp:win_space_toggle" ];
    };
  };
}
