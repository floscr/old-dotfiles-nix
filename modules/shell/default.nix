{ config, lib, pkgs, ... }:

{
  imports = [
    ./beancount.nix
    ./colorOptimization.nix
    ./direnv.nix
    ./git.nix
    ./gnupg.nix
    ./mail.nix
    ./ncmpcpp.nix
    ./pass.nix
    ./weechat.nix
    ./zsh.nix
  ];
}
