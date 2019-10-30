#Enables bluetooth headset using bluez5 and pulseaudio
{ pkgs, ... }:

{
  #sudo rfkill unblock bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    extraConfig = ''
        ControllerMode = bredr
        AutoConnect=true
        [Headset]
        HFP=true
        MaxConnected=1
        FastConnectable=true
        [General]
        Enable=Source,Sink,Media,Socket
        '';
  };
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };

  nixpkgs.config = {
    packageOverrides = pkgs: {
      bluez = pkgs.bluez5;
    };
  };

  environment.systemPackages = [
    pkgs.pavucontrol
    pkgs.blueman
    pkgs.spotify
  ];
}
