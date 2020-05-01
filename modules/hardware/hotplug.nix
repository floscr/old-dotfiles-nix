{ config, pkgs, ... }:

let
  xrandr = "${pkgs.xorg.xrandr}/bin/xrandr";
  grep = "${pkgs.gnugrep}/bin/grep";
  bspc = "${pkgs.bspwm}/bin/bspc";
  sleep = "${pkgs.coreutils}/bin/sleep";
in {
  systemd.user.services."hotplug-monitor@" = {
    enable = true;
    description = "Hotplug Monitor";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = false;
      ExecStart = "${pkgs.systemd}/bin/systemctl --user restart setup-monitor.service";
    };
  };

  systemd.user.services."setup-monitor" = {
    enable = true;
    description = "Load my monitor modifications";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/bash ${pkgs.writeScript "hotplug-monitor.sh" ''
#!${pkgs.stdenv.shell}

echo "Starting monitor hotplug"

function connectLG(){
  ${xrandr} \
    --output eDP1 --off \
    --output DP2 \
    --primary \
    --dpi 110 \
    --panning 3840x2160 \
    --mode 3840x2160 \
    --pos 0x0 \
    --rotate normal \
    --auto

  ${pkgs.bspwm}/bin/bspc window_gap 8
}

function disconnect(){
  ${xrandr} \
    --output VIRTUAL1 --off \
    --output DP1 --off \
    --output DP2 --off \
    --output DP1 --off \
    --output HDMI1 --off \
    --output HDMI2 --off \
    --output eDP1 \
    --primary \
    --dpi 92 \
    --auto


  ${pkgs.bspwm}/bin/bspc window_gap 0

}

if [[ $(${xrandr} | ${grep} "^DP2 connected") ]]; then
  connectLG
else
  disconnect
fi

${pkgs.systemd}/bin/systemctl --user restart polybar.service;
${pkgs.systemd}/bin/systemctl --user restart wallpaper.service;

# Reset windows overlaying polybar
${sleep} 1
${bspc} config borderless_monocle true
      ''}";
    };
  };

  # Jesus christ udev
  # https://superuser.com/a/1401322
  services.udev.extraRules = ''
    ACTION=="change", KERNEL=="card0", SUBSYSTEM=="drm", ENV{HOTPLUG}=="1", ENV{SYSTEMD_USER_WANTS}+="hotplug-monitor@$env{SEQNUM}.service", TAG+="systemd"
  '';
}
