{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.desktop.apps.blender = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.desktop.apps.blender.enable {
    my = {
      packages = with pkgs; [
        blender
      ];
      bindings = [
        {
          description = "Blender";
          categories = "Graphics, 3D";
          command = "blender";
        }
      ];
    };
  };
}
