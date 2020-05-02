{ config, lib, pkgs, ... }:

{
  users.groups.vboxusers.members = [ "floscr" ];

  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };

  my.user = {
    extraGroups = [
      "vboxusers"
    ];
  };
}
