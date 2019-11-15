{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    hue-cli
  ];
}
