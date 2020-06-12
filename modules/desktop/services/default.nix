{ config, lib, pkgs, ... }:
with lib;
{
  imports = [
    ./hotplug.nix
    ./lockscreen.nix
    ./notifications.nix
    ./polybar.nix
    ./redshift.nix
    ./wallpaper.nix
  ];
}
