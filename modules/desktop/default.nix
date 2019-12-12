{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    redshift
    xclip
    xdotool
    ffmpeg
    mpv
    feh
    imagemagickBig

    # Useful apps
    # evince    # pdf reader
  ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services = {
    physlock = {
      enable = true;
      lockOn = {
        suspend = true;
        hibernate = true;
      };
    };

    xserver = {
      enable = true;
      # Enable laptop trackpads.
      synaptics.enable = true;
      synaptics.additionalOptions = ''
        Option "VertScrollDelta" "100"
        Option "HorizScrollDelta" "100"
      '';
      synaptics.palmDetect = true;
      synaptics.minSpeed = ".9";
      synaptics.maxSpeed = "1.4";
      synaptics.accelFactor = "0.005";
      synaptics.buttonsMap = [ 1 2 3 ];
      synaptics.fingersMap = [ 1 3 2 ];
      synaptics.twoFingerScroll = true;
      synaptics.vertEdgeScroll = false;
    };

    redshift = {
      enable = true;
      temperature = {
        day = 5500;
        night = 3000;
      };
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
