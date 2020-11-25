{ config, lib, pkgs, ... }:

{
  imports = [
    ./android.nix
    ./atd.nix
    ./emacsGit.nix
    ./hhpc.nix
    ./jellyfin.nix
    ./mpd.nix
    ./suspendFix.nix
    ./syncthing.nix
    ./virtualbox.nix
    ./wireguard.nix
  ];
}
