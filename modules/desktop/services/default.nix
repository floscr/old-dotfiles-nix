{ config, lib, pkgs, ... }:
with lib;
{
  imports = [
    ./greenclip.nix
    ./hotplug.nix
    ./lockscreen.nix
    ./notifications.nix
    ./polybar.nix
    ./redshift.nix
    ./wallpaper.nix
  ];
}
