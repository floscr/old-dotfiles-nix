{ config, lib, pkgs, ... }:

{
  imports = [
    ../services/hhpc.nix
    ../services/syndaemon.nix
  ];

  # Hide the mouse cursor after idle
  systemd.user.services.hhpc.enable = true;

  # Disable touchpad while typing
  systemd.user.services.syndaemon.enable = true;

  services.xserver.synaptics = {
    enable = true;
    additionalOptions = ''
        Option "VertScrollDelta" "100"
        Option "HorizScrollDelta" "100"
      '';
    palmDetect = true;
    minSpeed = ".9";
    maxSpeed = "1.4";
    accelFactor = "0.005";
    buttonsMap = [ 1 2 3 ];
    fingersMap = [ 1 3 2 ];
    twoFingerScroll = true;
    vertEdgeScroll = false;
  };
}