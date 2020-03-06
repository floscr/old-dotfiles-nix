{ config, lib, pkgs, ... }:

{
  imports = [ ./. ];

  # Support for more filesystems
  environment.systemPackages = with pkgs; [
    exfat
    ntfs3g
    hfsprogs
  ];
  boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];

  # Nothing in /tmp should survive a reboot
  boot.tmpOnTmpfs = true;

  # Use simple bootloader; I prefer the on-demand BIOs boot menu
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
