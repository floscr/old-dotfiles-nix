{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.desktop.apps.gimp = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.desktop.apps.gimp.enable {
    my = {
      packages = with pkgs; [
        gimp
        gimpPlugins.resynthesizer2
      ];

      home.xdg.configFile = {
        "GIMP/2.10" = { source = <config/gimp>; recursive = true; };
      };

      bindings = [
        {
          description = "Gimp";
          categories = "Graphics";
          command = "gimp";
        }
      ];
    };
  };
}
