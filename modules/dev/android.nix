{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    androidenv
    ant
    openjdk
  ];
}
