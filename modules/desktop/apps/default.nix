{ config, lib, pkgs, ... }:

{
  imports = [
    ./rofi.nix
    ./spotify.nix
    ./flameshot.nix
  ];
}
