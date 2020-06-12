{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.shell.gnupg = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.shell.gnupg.enable {
    my = {
      packages = with pkgs; [
        gnupg
        pinentry
      ];
    };
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
