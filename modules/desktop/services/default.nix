{ config, lib, pkgs, ... }:
with lib;
{
  imports = [
    ./battery-notifier.nix
    ./greenclip.nix
    ./hotplug.nix
    ./lockscreen.nix
    ./notifications.nix
    ./polybar.nix
    ./redshift.nix
    ./keyboardTrackpadDisable.nix
    ./wallpaper.nix
  ];
}
