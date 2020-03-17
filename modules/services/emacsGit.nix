{ config, lib, pkgs, ... }:

{
  systemd.user.services.emacs = {
    description = "Emacs Daemon";

    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.emacsGit}/bin/emacs --daemon";
      ExecStop = "${pkgs.emacsGit}/bin/emacsclient --eval (kill-emacs)";
      Restart = "always";
    };

    wantedBy = [ "default.target" ];
  };
}
