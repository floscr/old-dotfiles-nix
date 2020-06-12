{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Mount OSX formated drives
    hfsprogs
  ];
}
