{ config, lib, pkgs, ... }:

{
  imports = [
    ./youtube-dl.nix
    ./ncmpcpp.nix
    ./mpv/default.nix
  ];
}
