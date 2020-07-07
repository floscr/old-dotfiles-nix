{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.services.suspendFix = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.services.suspendFix.enable {
    my.packages = with pkgs; [
      msr-tools
    ];
    systemd.services.suspendFix = {
      description = "Flushes the cpu clock modulation MSR to relase cpu lock caused by BIOS bug";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.msr-tools}/bin/wrmsr -a 0x19a 0x0";
      };
      wantedBy = [ "suspend.target" ];
      after = [ "suspend.target" ];
    };
    systemd.services.suspendFix.enable = true;
  };
}
