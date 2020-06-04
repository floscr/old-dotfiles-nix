{ config, lib, pkgs, ... }:

{
  # Hardware
  hardware.sane.enable = true;
  hardware.sane.extraBackends = with pkgs; [
    epkowa
    utsushi
  ];
  services.udev.packages = [ pkgs.utsushi ];

  # Additional Software
  my.packages = with pkgs; [
    scantailor
  ];
}
