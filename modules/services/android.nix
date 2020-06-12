{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.services.android = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.services.android.enable {
    my = {
      packages = with pkgs; [
        jmtpfs # to mount android
      ];
    };
  };
}
