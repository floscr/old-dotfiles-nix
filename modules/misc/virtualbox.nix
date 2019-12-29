{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    virtualbox
  ];

  users.groups.vboxusers.members = [ "floscr" ];

  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };
}
