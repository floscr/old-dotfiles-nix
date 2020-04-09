{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    transmission
  ];
  my.home.xdg.mimeApps = {
    associations.added= {
      "x-scheme-handler/magnet" = "transmission-gtk.desktop";
    };
    defaultApplications = {
      "x-scheme-handler/magnet" = "transmission-gtk.desktop";
    };
  };
}
