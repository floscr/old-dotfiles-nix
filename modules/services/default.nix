{ config, lib, pkgs, ... }:

{
  imports = [
    ./emacsGit.nix
    ./hhpc.nix
    ./mpd.nix
    ./syncthing.nix
    ./virtualbox.nix
    ./wireguard.nix
  ];
}
