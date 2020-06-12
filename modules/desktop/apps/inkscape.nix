{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.desktop.apps.inkscape = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.desktop.apps.inkscape.enable {
    my = {
      packages = with pkgs; [
        inkscape
      ];
      bindings = [
        {
          description = "Inkscape";
          categories = "Graphics, Vector";
          command = "inkscape";
        }
      ];
    };
  };
}
