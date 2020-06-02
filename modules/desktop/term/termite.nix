{ config, lib, pkgs, ... }:

let
  font = "Iosevka";
in
with lib;
{
  options.modules.desktop.term.termite = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.term.termite.enable {
    my.packages = with pkgs; [
      (pkgs.writeScriptBin "termite-refresh-ui" ''
        #! ${pkgs.bash}/bin/bash
        ${pkgs.killall}/bin/killall -USR1 -r termite | true
      '')
    ];

    my.home.programs = {
      termite = {
        enable = true;
        font = "${font} 8";
        backgroundColor = config.theme.colors.terminalBackground;
        foregroundColor = config.theme.colors.text;
        scrollbackLines = -1;
        allowBold = true;
        clickableUrl = true;
        cursorBlink = "off";
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

    my.bindings = [
      {
        description = "Termite";
        categories = "Terminal";
        command = "termite";
      }
      {
        description = "htop";
        categories = "Activity Monitor";
        command = "termite -e htop";
      }
      {
        description = "s-tui";
        categories = "Heat Sensors";
        command = "termite -e s-tui";
      }
    ];
  };
}
