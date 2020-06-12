{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.shell.colorOptimization = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.shell.colorOptimization.enable {
    my = {
      packages = with pkgs; [
        libjpeg
        optipng
      ];
    };
  };
}
