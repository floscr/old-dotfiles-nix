{ config, lib, pkgs, ... }:

{
  boot.initrd.availableKernelModules = [ "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  boot.loader.grub.enable = false;
  boot.loader.raspberryPi.enable = true;
  boot.loader.raspberryPi.version = 4;
  boot.kernelPackages = pkgs.linuxPackages_rpi4;

  environment.systemPackages = with pkgs; [
    raspberrypi-tools
  ];

  documentation.nixos.enable = false;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 30d";
  boot.cleanTmpDir = true;

  # Increase `cma` to 64M to allow to use all of the RAM.
  # NOTE: this disables the serial console. Add
  # "console=ttyS0,115200n8" "console=ttyAMA0,115200n8" to restore.
  boot.kernelParams = ["cma=64M" "console=tty0"];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
      fsType = "ext4";
    };
  # Use 1GB of additional swap memory in order to not run out of memory
  # when installing lots of things while running other things at the same time.
  swapDevices = [ { device = "/swapfile"; size = 1024; } ];

  system.stateVersion = "20.09";
}
