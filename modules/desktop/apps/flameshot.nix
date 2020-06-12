{ config, options, lib, pkgs, ... }:

with lib;
{
  options.modules.desktop.apps.flameshot = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.desktop.apps.flameshot.enable {
    my = {
      packages = with pkgs; [
        flameshot
      ];
      home.xdg.configFile = {
        "Dharkael/flameshot.ini".text = ''
          [General]
          closeAfterScreenshot=true
          disabledTrayIcon=true
          drawColor=${config.theme.colors.bmag}
          drawThickness=0
          filenamePattern=Screenshot-%y%m%d-%H%M%S
          savePath=/home/${config.my.username}/Media/Screenshots
          showDesktopNotification=false
          showHelp=false
          uiColor=${config.theme.colors.blue}
        '';
      };
      bindings = [
        {
          description = "Flameshot";
          categories = "Screenshot";
          command = "flameshot gui";
        }
      ];
    };
  };
}
