{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    jmtpfs # to mount android
  ];
}
