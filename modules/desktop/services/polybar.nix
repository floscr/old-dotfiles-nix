{ config, lib, pkgs, ... }:

let polybar = pkgs.polybar.override {
  mpdSupport = true;
  pulseSupport = true;
  nlSupport = true;
    };
in {
  my.packages = [
    polybar
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
    path = with pkgs; [ polybar pulseaudio gawk ];
    serviceConfig = {
      Type = "forking";
      Restart = "on-failure";
    };
  };

}
