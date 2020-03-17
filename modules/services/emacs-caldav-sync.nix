{ config, lib, pkgs, ... }:

{
  systemd.timers.emacs-caldav-sync = {
    wantedBy = [ "timers.target" ];
    partOf = [ "emacs-caldav-sync.service" ];
    timerConfig.OnCalendar = "daily";
  };
  systemd.services.emacs-caldav-sync = {
    requires = [ "network-online.target" "emacs.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
        ${pkgs.emacs}/bin/emacsclient -a "" -e '(org-caldav-sync)'
    '';
  };
}
