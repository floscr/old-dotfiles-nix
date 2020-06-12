{ config, options, lib, pkgs, ... }:
# Hide the cursor when it's inactive

with lib;

{
  options.modules.services.hhpc = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.services.hhpc.enable {
    my = {
      packages = with pkgs; [
        hhpc
      ];
    };

    systemd.user.services.hhpc = {
      description = "HHPC Daemon (Hide Mouse Cursor)";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.hhpc}/bin/hhpc -i 5";
        ExecStop = "${pkgs.procps}/bin/pkill hhpc";
      };
    };
  };
}
