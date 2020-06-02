{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      nim
  ];
}
