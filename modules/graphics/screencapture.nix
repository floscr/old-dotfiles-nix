{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    simplescreenrecorder
    flameshot
  ];

  my.home.xdg.configFile = {
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
  my.bindings = [
    {
      description = "SimpleScreenRecorder";
      categories = "Video";
      command = "simplescreenrecorder";
    }
    {
      description = "Flameshot";
      categories = "Screenshot";
      command = "flameshot gui";
    }
  ];
}
