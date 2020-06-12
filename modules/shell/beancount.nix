{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.beancount = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.beancount.enable {
    my = {
      packages = with pkgs; [
        beancount
      ];
    };
  };
}
