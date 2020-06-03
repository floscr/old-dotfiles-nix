{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      nim
  ];
  my = {
    zsh.rc = lib.readFile <config/nim/aliases.zsh>;
  };
}
