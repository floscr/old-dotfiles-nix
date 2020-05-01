{ config, lib, pkgs, ... }:

{
  imports = [ ./. ];

  environment = {
    systemPackages = with pkgs; [
      lightdm
      sxhkd
      (polybar.override {
        mpdSupport = true;
        pulseSupport = true;
        nlSupport = true;
      })
    ];
  };

  systemd.user.services.polybar = {
    description = "Polybar daemon";
    wantedBy = [ "multi-user.target" ];
    partOf = [ "multi-user.target" ];
    serviceConfig = {
      Type = "forking";
    };
    script = let
      polybar = "${pkgs.polybar}/bin/polybar";
      xrandr = "${pkgs.xorg.xrandr}/bin/xrandr";
      grep = "${pkgs.gnugrep}/bin/grep";
    in lib.mkDefault ''
${polybar} main &
      '';
  };

  systemd.user.services.wallpaper = {
    description = "Feh Daemon";
    wantedBy = [ "multi-user.target" ];
    partOf = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
    };
    script = let
      feh = "${pkgs.feh}/bin/feh";
    in lib.mkDefault "${feh} --no-fehbg --bg-scale /etc/dotfiles/modules/themes/glimpse/wallpaper.png";
  };

  services = {
    xserver = {
      windowManager.default = "bspwm";
      windowManager.bspwm.enable = true;
    };
  };

  my.home.xdg.configFile = {
    "sxhkd".source = <config/sxhkd>;
    "bspwm" = { source = <config/bspwm>; recursive = true; };
    "polybar" = { source = <config/polybar>; recursive = true; };
  };
}
