{ config, lib, pkgs, ... }:

{
  imports = [
    ./mpd.nix
    ./syncthing.nix
    ./wireguard.nix
    ./emacsGit.nix
  ];
}
