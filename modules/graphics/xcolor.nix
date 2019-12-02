{ config, lib, pkgs, ... }:

let
  xcolor = pkgs.callPackages ../../packages/xcolor.nix { };
in {
  environment.systemPackages = with pkgs; [
    xcolor
  ];
}
