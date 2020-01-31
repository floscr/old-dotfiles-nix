{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gparted
    # Mount OSX formated drives
    hfsprogs
  ];
}
