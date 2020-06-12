{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.desktop.apps.transmission = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.desktop.apps.transmission.enable {
    my = {
      packages = with pkgs; [
        transmission
      ];
      home.xdg.mimeApps = {
        associations.added= {
          "x-scheme-handler/magnet" = "transmission-gtk.desktop";
        };
        defaultApplications = {
          "x-scheme-handler/magnet" = "transmission-gtk.desktop";
        };
      };
    };
  };
}
