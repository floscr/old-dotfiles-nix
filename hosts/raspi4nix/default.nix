{ config, lib, pkgs, ... }:

## Rasberry Pi 4

{
  imports = [
    ../personal.nix
    ./hardware-configuration.nix
  ];

  modules = {
    editors = {
      default = "nvim";
      vim.enable = true;
    };

    shell = {
      git.enable = true;
      gnupg.enable = true;
      zsh.enable = true;
    };
  };

  time.timeZone = "Europe/Vienna";

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Networking
  services.sshd.enable = true;
}
