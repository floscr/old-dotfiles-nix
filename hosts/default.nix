# hosts/default.nix --- settings common to all my systems

{ config, lib, pkgs, ... }:
{
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
