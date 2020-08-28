{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.desktop.apps.font-manager = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.desktop.apps.font-manager.enable {
    my = {
      packages = with pkgs; [
        font-manager
        (makeDesktopItem {
          name = "font-manager";
          desktopName = "Font Manager";
          genericName = "Font Manager";
          icon = "font-manager";
          exec = "${font-manager}/bin/font-manager";
          categories = "Etc";
        })
      ];
      home.xdg.mimeApps.defaultApplications = {
        "font/sfnt" = [ "font-manager.desktop" ];
      };
    };
  };
}
