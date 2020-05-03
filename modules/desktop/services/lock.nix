{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    i3lock-color
  ];
}
