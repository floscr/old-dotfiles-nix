{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    libjpeg
    optipng
  ];
}
