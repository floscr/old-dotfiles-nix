{ config, lib, pkgs, ... }:

{
  my.packages = with pkgs; [
    (polybar.override {
      mpdSupport = true;
      pulseSupport = true;
      nlSupport = true;
    })
  ];

  systemd.user.services.polybar = {
    description = "Polybar daemon";
    wantedBy = [ "multi-user.target" ];
    partOf = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.polybar}/bin/polybar main &";
      Restart = "always";
      Type = "forking";
    };
  };

  my.home.xdg.configFile = {
    "polybar" = { source = <config/polybar>; recursive = true; };
  };
}
