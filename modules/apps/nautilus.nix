{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnome3.nautilus
  ];
}
