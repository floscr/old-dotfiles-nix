{ config, lib, pkgs, ... }:

{
  imports = [
    ./blender.nix
    ./flameshot.nix
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
