{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      unstable.nim
  ];
  my = {
    # env.PATH = [<nimbin>];
  };
}
