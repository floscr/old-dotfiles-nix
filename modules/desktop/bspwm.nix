{ config, lib, pkgs, ... }:

{
  imports = [ ./. ];

  environment = {
    systemPackages = with pkgs; [
      lightdm
      sxhkd
      (polybar.override {
        mpdSupport = true;
        pulseSupport = true;
        nlSupport = true;
      })
    ];
  };

  services = {
    xserver = {
      windowManager.default = "bspwm";
      windowManager.bspwm.enable = true;
    };
  };

  my.home.xdg.configFile = {
    "sxhkd".source = <config/sxhkd>;
    "bspwm" = { source = <config/bspwm>; recursive = true; };
    "polybar" = { source = <config/polybar>; recursive = true; };
  };
}
