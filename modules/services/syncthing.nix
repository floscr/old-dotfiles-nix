{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.services.syncthing = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.services.syncthing.enable {
    my = {
      packages = with pkgs; [
        syncthing
      ];
    };
    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      user = "floscr";
      configDir = "/home/floscr/.config/syncthing";
      dataDir = "/home/floscr/sync";
    };
  };
}
