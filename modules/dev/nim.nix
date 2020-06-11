{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      nim
  ];
  my = {
    # env.PATH = [<nimbin>];
    zsh.rc = lib.readFile <config/nim/aliases.zsh>;
  };
}
