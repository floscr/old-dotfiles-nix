{ config, lib, pkgs, ... }:

{
  imports = [
    ./android.nix
    ./emacsGit.nix
    ./hhpc.nix
    ./mpd.nix
    ./syncthing.nix
    ./virtualbox.nix
    ./wireguard.nix
    ./suspendFix.nix
  ];
}
