{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.desktop.apps.gparted = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.desktop.apps.gparted.enable {
    my = {
      packages = with pkgs; [
        gparted
      ];
    };
  };
}
