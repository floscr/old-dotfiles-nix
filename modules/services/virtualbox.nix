{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.services.virtualbox = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.services.virtualbox.enable {
    users.groups.vboxusers.members = [ config.my.username ];

    virtualisation.virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };

    my.user.extraGroups = [ "vboxusers" ];
  };
}
