{ config, lib, pkgs, ... }:

{
  services.autorandr = {
    enable = true;
    defaultTarget = "main";
  };

  my.home.programs.autorandr = {
    enable = true;
    profiles = {
      mobile = {
        fingerprint = {
          eDP1 =
          "00ffffffffffff000daef21400000000161c0104a51f117802ee95a3544c99260f505400000001010101010101010101010101010101363680a0703820402e1e240035ad10000018000000fe004e3134304843472d4751320a20000000fe00434d4e0a202020202020202020000000fe004e3134304843472d4751320a2000bb";
        };
        config = {
          eDP1 = {
            enable = true;
            primary = true;
            mode = "1920x1080";
            position = "0x0";
            rate = "60.00";
          };
          DP1 = { enable = false; };
          DP2 = { enable = false; };
          HDMI1 = { enable = false; };
          HDMI2 = { enable = false; };
          VIRTUAL1 = { enable = false; };
        };
          hooks.postswitch = ''
            ${pkgs.bspwm}/bin/bspc config window_gap 8
            ${pkgs.bspwm}/bin/bspc monitor \^1 -d {1,2,3,4,5,6,7}
            ${pkgs.feh}/bin/feh --no-fehbg --bg-scale /etc/dotfiles/modules/themes/glimpse/wallpaper.png
            ${pkgs.polybar}/bin/polybar --reload main
          '';
      };
      work = {
        fingerprint = {
          eDP1 =
          "00ffffffffffff000daef21400000000161c0104a51f117802ee95a3544c99260f505400000001010101010101010101010101010101363680a0703820402e1e240035ad10000018000000fe004e3134304843472d4751320a20000000fe00434d4e0a202020202020202020000000fe004e3134304843472d4751320a2000bb";
          DP2 =
          "00ffffffffffff001e6d0777d6610100041d0104b53c22789e3e31ae5047ac270c50542108007140818081c0a9c0d1c08100010101014dd000a0f0703e803020650c58542100001a286800a0f0703e800890650c58542100001a000000fd00383d1e8738000a202020202020000000fc004c472048445220344b0a20202001330203197144900403012309070783010000e305c000e3060501023a801871382d40582c450058542100001e565e00a0a0a029503020350058542100001a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000029";
        };
        config = {
          eDP1 = { enable = false; };
          DP1 = { enable = false; };
          DP2 = {
            enable = true;
            primary = true;
            mode = "3840x2160";
            position = "0x0";
            rate = "60.00";
          };
          HDMI1 = { enable = false; };
          HDMI2 = { enable = false; };
          VIRTUAL1 = { enable = false; };
        };
      hooks.postswitch = ''
            ${pkgs.bspwm}/bin/bspc config window_gap 8
            ${pkgs.bspwm}/bin/bspc monitor \^1 -d {1,2,3,4,5,6,7}
            ${pkgs.feh}/bin/feh --no-fehbg --bg-scale /etc/dotfiles/modules/themes/glimpse/wallpaper.png
            ${pkgs.polybar}/bin/polybar --reload main
          '';
      };

    };
  };
}
