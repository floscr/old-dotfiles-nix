{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ruby
  ];
  my.zsh.rc = lib.readFile ./env.zsh;
}
