{ config, lib, pkgs, ... }:

with lib;

let polybar = pkgs.polybar.override {
  mpdSupport = true;
  pulseSupport = true;
  nlSupport = true;
};
in {
  options.modules.desktop.services.polybar = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf config.modules.desktop.services.polybar.enable {
    my.packages = [
      polybar
      (pkgs.writeScriptBin "toggle-polybar" ''
        if pgrep polybar >/dev/null; then
            systemctl --user stop polybar.service
            bspc config top_padding 0
        else
            systemctl --user start polybar.service
            bspc config top_padding 36
        fi
      '')
      (pkgs.writeScriptBin "bluetooth-battery" ''
        DEVICE=$(${pkgs.bluez}/bin/bluetoothctl info | grep -o "[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]" | head -1)
        CHARGE=$(${pkgs.python3.withPackages (ps: [ ps.pybluez ])}/bin/python3 ${./bluetooth_battery.py} $DEVICE.$@)
        if (( CHARGE >= 0 && CHARGE <= 100 )); then
          echo " "$CHARGE"%"
        else
          echo " OFF"
        fi

     '')
    ];

    my.home.xdg.configFile = {
      "polybar" = { source = <config/polybar>; recursive = true; };
    };

    systemd.user.services.polybar = {
      description = "Polybar daemon";
      after = [ "graphical-session-pre.target" ];
      wantedBy = [ "graphical-session-pre.target" ];
      partOf = [ "graphical-session-pre.target" ];
      restartTriggers = [ "~/.config/polybar/config" ];
      script = ''
          polybar main &
        '';
      path = with pkgs; [
        bash
        gawk
        networkmanager
        polybar
        pulseaudio
      ];
      serviceConfig = {
        Type = "forking";
        Restart = "on-failure";
      };
    };
  };
}
