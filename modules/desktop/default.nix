{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rofi
    redshift
    xclip
    xdotool
    ffmpeg
    feh
    imagemagickBig

    # Useful apps
    # evince    # pdf reader
  ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = lib.mkDefault false;
    displayManager.lightdm.greeters.mini.user = config.my.username;
    displayManager.lightdm.enable = true;
    displayManager.lightdm.greeters.mini.enable = true;
    displayManager.sessionCommands = ''
      # disable Display Power Managing Signaling
      xset -dpms

      # Trackpad settings
      xinput set-prop 13 317 0.7 # Speed
      xinput set-prop 13 318 3, 3 # Sensitivity

      greenclip daemon&
      dunst&

      sh ~/.config/polybar/launch.sh&
    '';
  };

  services.redshift = {
    enable = true;
    temperature = {
      day = 5500;
      night = 3000;
    };
  };

  location = {
    longitude = 12.5;
    latitude = 55.88;
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;

    fonts = with pkgs; [
      ubuntu_font_family
      dejavu_fonts
      fira-code
      fira-code-symbols
      symbola
      noto-fonts
      noto-fonts-cjk
      font-awesome-ttf
    ];

    fontconfig.defaultFonts = {
      sansSerif = ["Ubuntu"];
      monospace = ["Fira Code"];
    };
  };
}
