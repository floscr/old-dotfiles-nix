{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    youtube-dl
  ];
}
