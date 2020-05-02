# docker

{ config, lib, pkgs, ... }:
with lib;
{
  options.modules.dev.docker = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.dev.docker.enable {
    virtualisation = {
      docker = {
        enable = true;
        autoPrune.enable = true;
        enableOnBoot = false;
      };
    };

    my.packages = with pkgs; [
      docker
      docker-compose
    ];

    environment.shellAliases = {
      docker-killall = "docker stop $(docker ps -q)";
    };

    my.user = {
      extraGroups = [
        "docker"
      ];
    };
  };
}
