{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.nixos.cachix = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.nixos.cachix.enable {
    my = {
      packages = with pkgs; [
        pkgs.cachix
      ];
    };
  };
}
