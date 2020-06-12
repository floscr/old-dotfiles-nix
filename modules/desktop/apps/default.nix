{ config, lib, pkgs, ... }:

{
  imports = [
    ./blender.nix
    ./flameshot.nix
    ./gimp.nix
    ./inkscape.nix
    ./krita.nix
    ./rofi.nix
    ./spotify.nix
  ];
}
