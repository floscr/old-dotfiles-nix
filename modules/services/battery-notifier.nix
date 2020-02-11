{ config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.batteryNotifier;
in
{
  options = {
    services.batteryNotifier = {enable = mkOption {
        default = false;
        description = ''
          Whether to enable battery notifier.
        '';
      };
      device = mkOption {
        default = "BAT0";
        description = ''
          Device to monitor.
        '';
      };
      cacheFile = mkOption {
        default = "/tmp/battery-notifier-cache";
        description = ''
          File to save the last battery status time, so you don't get the same nagging warning every minute.
        '';
      };
      notifyCapacity = mkOption {
        default = 10;
        description = ''
          Battery level at which a notification shall be sent.
        '';
      };
      suspendCapacity = mkOption {
        default = 5;
        description = ''
          Battery level at which a suspend unless connected shall be sent.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.user.timers."lowbatt" = {
      description = "check battery level";
      timerConfig.OnBootSec = "1m";
      timerConfig.OnUnitInactiveSec = "1m";
      timerConfig.Unit = "lowbatt.service";
      wantedBy = ["timers.target"];
    };
    systemd.user.services."lowbatt" = {
      description = "battery level notifier";
      script = ''
        export battery_capacity=$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/${cfg.device}/capacity)
        export battery_status=$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/${cfg.device}/status)

        # Remove cache file once the machine is charged again
        if [[ $battery_capacity -ge ${builtins.toString cfg.notifyCapacity} && -f ${cfg.cacheFile} ]]; then
          rm ${cfg.cacheFile}
        fi

        if [[ $battery_capacity -le ${builtins.toString cfg.notifyCapacity} && $battery_status = "Discharging" && ! -f ${cfg.cacheFile} ]]; then
            touch ${cfg.cacheFile}
            ${pkgs.libnotify}/bin/notify-send --urgency=critical --hint=int:transient:1 --icon=battery_empty "Battery Low" "You should probably plug-in."
        fi

        if [[ $battery_capacity -le ${builtins.toString cfg.suspendCapacity} && $battery_status = "Discharging" ]]; then
            ${pkgs.libnotify}/bin/notify-send --urgency=critical --hint=int:transient:1 --icon=battery_empty "Battery Critically Low" "Computer will suspend in 60 seconds."
            sleep 60s

            battery_status=$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/${cfg.device}/status)
            if [[ $battery_status = "Discharging" ]]; then
                systemctl suspend
            fi
        fi
      '';
    };
  };
}
