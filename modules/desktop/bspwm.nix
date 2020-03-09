{ config, lib, pkgs, ... }:

{
  imports = [ ./. ];

  environment = {
    systemPackages = with pkgs; [
      lightdm
      xcape
      sxhkd
      bspwm
      (polybar.override {
        mpdSupport = true;
        pulseSupport = true;
        nlSupport = true;
      })
    ];
  };

  services = {
    xserver = {
      windowManager.default = "bspwm";
      windowManager.bspwm.enable = true;
    };
  };

  home-manager.users.floscr = {

    xdg.configFile = {
      "sxhkd".source = <config/sxhkd>;

        # link recursively so other modules can link files in their folders, e.g.
        # ~/.config/bspwm/rc.d and ~/.config/rofi/theme
        "bspwm" = { source = <config/bspwm>; recursive = true; };
        "polybar" = { source = <config/polybar>; recursive = true; };
    };
  };
}
