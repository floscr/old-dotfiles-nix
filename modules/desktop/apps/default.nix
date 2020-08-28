{ config, lib, pkgs, ... }:

{
  imports = [
    ./blender.nix
    ./flameshot.nix
    ./font-manager.nix
    ./gimp.nix
    ./gparted.nix
    ./inkscape.nix
    ./krita.nix
    ./rofi.nix
    ./spotify.nix
    ./transmission.nix
    ./xcolor.nix
  ];
}
