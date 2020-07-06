{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.desktop.services.wallpaper = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.services.wallpaper.enable {
    systemd.user.services.wallpaper = {
      description = "Feh Daemon";
      wantedBy = [ "multi-user.target" ];
      partOf = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.feh}/bin/feh --no-fehbg --bg-scale ${config.theme.wallpaper}";
      };
    };
  };
}
