{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    dunst
    libnotify
  ];
}
