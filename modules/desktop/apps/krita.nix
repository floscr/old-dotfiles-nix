{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.desktop.apps.krita = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.desktop.apps.krita.enable {
    my = {
      packages = with pkgs; [
        krita
      ];
      bindings = [
        {
          description = "Krita";
          categories = "Graphics";
          command = "krita";
        }
      ];
    };
  };
}
