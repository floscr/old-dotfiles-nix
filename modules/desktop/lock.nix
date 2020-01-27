{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    i3lock-color
  ];
  services.screen-lockersk.lockCmd = lib.mkForce "${pkgs.i3lock-color}/bin/i3lock-color --clock --color=ffa500 --show-failed-attempts --bar-indicator --datestr='%A %Y-%m-%d' -i $(${pkgs.coreutils}/bin/shuf -n1 -e /home/risson/haltode/*.jpg)";
}
