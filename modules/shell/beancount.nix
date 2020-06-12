{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.shell.beancount = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.shell.beancount.enable {
    my = {
      packages = with pkgs; [
        beancount
      ];
    };
  };
}
