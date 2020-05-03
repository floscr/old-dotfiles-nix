{ config, lib, pkgs, ... }:

{
  imports = [
    ./bspwm.nix

    ./browsers
  ];
}
