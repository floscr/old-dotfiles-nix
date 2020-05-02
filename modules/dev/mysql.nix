# mysql

{ config, options, lib, pkgs, ... }:
with lib;
{
  options.modules.dev.mysql = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.dev.mysql.enable {
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
  };
}
