{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.docker
    pkgs.docker-compose
  ];
}
