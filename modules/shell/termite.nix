{ config, lib, pkgs, ... }:


let
  font = "Iosevka";
in
{
  home-manager.users.floscr.programs = {
    termite = {
      enable = true;
      font = "${font} 8";
      backgroundColor = config.theme.colors.terminalBackground;
      foregroundColor = config.theme.colors.text;
      scrollbackLines = -1;
      allowBold = true;
      clickableUrl = true;
      dynamicTitle = true;
      geometry = "81x20";
      mouseAutohide = true;
      colorsExtra = with config.theme.colors; ''
        color0  = ${terminalBackground}
        color7  = ${text}
        color8  = ${grey2}
        color1  = ${red}
        color9  = ${bred}
        color2  = ${grn}
        color10 = ${bgrn}
        color3  = ${yellow}
        color11 = ${byellow}
        color4  = ${blue}
        color12 = ${bblue}
        color5  = ${mag}
        color13 = ${bmag}
        color6  = ${cyn}
        color14 = ${bcyn}
        color15 = ${white}
      '';
    };
  };
}
