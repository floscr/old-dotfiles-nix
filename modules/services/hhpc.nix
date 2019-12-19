{ config, lib, pkgs, ... }:

# Hide the cursor when it's inactive
{
  environment.systemPackages = with pkgs; [
    hhpc
  ];

  systemd.user.services.hhpc = {
    description = "HHPC Daemon (Hide Mouse Cursor)";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.hhpc}/bin/hhpc -i 5";
      ExecStop = "${pkgs.procps}/bin/pkill hhpc";
    };
  };
}
