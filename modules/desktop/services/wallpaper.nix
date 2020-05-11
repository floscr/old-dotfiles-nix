{ config, lib, pkgs, ... }:

{
  systemd.user.services.wallpaper = {
    description = "Feh Daemon";
    wantedBy = [ "multi-user.target" ];
    partOf = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.feh}/bin/feh --no-fehbg --bg-scale ${config.theme.wallpaper}";
    };
  };
}
