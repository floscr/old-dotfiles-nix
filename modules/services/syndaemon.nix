{ config, lib, pkgs, ... }:

# Disable touchpad while typing
{
  systemd.user.services.syndaemon = {
    description = "SynDaemon (Disable touchpad while typing)";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.xorg.xf86inputsynaptics}/bin/syndaemon -K -i 0.5";
      ExecStop = "${pkgs.procps}/bin/pkill syndaemon";
    };
  };
}
