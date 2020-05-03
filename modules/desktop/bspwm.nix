{ config, lib, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./services/lock.nix
    ./services/notifications.nix
    ./services/polybar.nix
    ./services/redshift.nix
    ./services/wallpaper.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      lightdm
      sxhkd
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
  };
}
