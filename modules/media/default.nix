{ config, lib, pkgs, ... }:

{
  imports = [
    ./youtube-dl.nix
    ./mpv.nix
  ];
}
