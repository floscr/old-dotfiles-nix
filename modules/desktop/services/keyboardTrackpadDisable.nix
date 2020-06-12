{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.desktop.services.keyboardTrackpadDisable = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.services.keyboardTrackpadDisable.enable {
    systemd.user.services.keyboardTrackpadDisable = {
      description = "SynDaemon (Disable touchpad while typing)";
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.xorg.xf86inputsynaptics}/bin/syndaemon -K -i 0.5";
        ExecStop = "${pkgs.procps}/bin/pkill syndaemon";
      };
    };
    systemd.user.services.keyboardTrackpadDisable.enable = true;
  };
}
