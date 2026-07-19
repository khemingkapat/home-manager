{ config, pkgs, lib, isDesktop, ... }:

lib.mkIf isDesktop {
  systemd.user.services.auto-power-settings = {
    Unit = {
      Description = "Auto Power Settings on AC/Battery";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.writeShellScript "auto-power-settings.sh" ''
        # Function to apply settings based on AC state
        apply_power_settings() {
            if /usr/sbin/on_ac_power; then
                # On charging: Always on (0), no idle dim (false)
                ${pkgs.glib}/bin/gsettings set org.gnome.desktop.session idle-delay 0
                ${pkgs.glib}/bin/gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
            else
                # On battery: Auto screen blank after 10 min (600), dim screen (true)
                ${pkgs.glib}/bin/gsettings set org.gnome.desktop.session idle-delay 600
                ${pkgs.glib}/bin/gsettings set org.gnome.settings-daemon.plugins.power idle-dim true
            fi
        }

        # Apply settings immediately on startup
        apply_power_settings

        # Monitor UPower for changes
        ${pkgs.dbus}/bin/dbus-monitor --system "type='signal',interface='org.freedesktop.DBus.Properties',path='/org/freedesktop/UPower/devices/line_power_AC'" | while read -r line; do
            if echo "$line" | ${pkgs.gnugrep}/bin/grep -q "PropertiesChanged"; then
                # wait a second for state to settle
                ${pkgs.coreutils}/bin/sleep 1
                apply_power_settings
            fi
        done
      ''}";
      Restart = "always";
      RestartSec = "3";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
