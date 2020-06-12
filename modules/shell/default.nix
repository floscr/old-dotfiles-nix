{ config, lib, pkgs, ... }:

{
  imports = [
    ./colorOptimization.nix
    ./direnv.nix
    ./git.nix
    ./gnupg.nix
    ./ncmpcpp.nix
    ./pass.nix
    ./weechat.nix
    ./zsh.nix
  ];
}
