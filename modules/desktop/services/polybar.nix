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
      # restartTriggers = [ config.my.home.xdg.configFile."polybar".source ];
      script = ''
          polybar main &
        '';
      path = with pkgs; [
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
