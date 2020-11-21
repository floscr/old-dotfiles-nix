{ config, lib, pkgs, ... }:
with lib;
{
  imports = [
    ./battery-notifier.nix
    ./greenclip.nix
    ./hotplug.nix
    ./keyboardTrackpadDisable.nix
    ./lockscreen.nix
    ./notifications.nix
    ./polybar.nix
    ./profile-sync-daemon.nix
    ./redshift.nix
    ./wallpaper.nix
  ];
}
