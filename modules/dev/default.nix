{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    jq
    gnumake
    pandoc
  ];
}
