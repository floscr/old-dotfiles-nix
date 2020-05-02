{ config, lib, pkgs, ... }:

{
  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
      enableOnBoot = false;
    };
  };

  environment.systemPackages = [
    pkgs.docker
    pkgs.docker-compose
  ];

  environment.shellAliases = {
    docker-killall = "docker stop $(docker ps -q)";
  };

  my.user = {
    extraGroups = [
      "docker"
    ];
  };
}
