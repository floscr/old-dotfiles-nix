{ config, lib, pkgs, ... }:

{
  imports = [
    ./apps
    ./browsers
    ./bspwm.nix
    ./keyboard.nix
  ];
}
