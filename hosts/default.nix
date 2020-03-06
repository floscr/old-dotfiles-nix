# hosts/default.nix --- settings common to all my systems

{ config, lib, pkgs, ... }:
{
  # Just the bear necessities~
  environment.systemPackages = with pkgs; [
    coreutils
    git
    killall
    networkmanager
    networkmanagerapplet
    unzip
    vim
    wget
  ];

  ### My user settings
  my.user = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "video"
      "networkmanager"
      "docker"
      "vboxusers"
    ];
    shell = pkgs.zsh;
  };

}
