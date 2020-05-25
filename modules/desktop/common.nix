{ config, lib, pkgs, ... }:

{
  my.packages = with pkgs; [
    dragon-drop
    feh
    ffmpeg
    imagemagickBig
    xcape
    xclip
    xdotool
  ];

  ## Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  ## X
  services.xserver = {
    enable = true;
    displayManager.lightdm.greeters.mini.user = config.my.username;
    displayManager.lightdm.enable = true;
    displayManager.lightdm.greeters.mini.enable = true;
    displayManager.sessionCommands = ''
      # disable Display Power Managing Signaling
      xset -dpms

      # Trackpad settings
      xinput set-prop 13 317 0.7 # Speed
      xinput set-prop 13 318 3, 3 # Sensitivity

      systemctl --user start setup-keyboard.service
      systemctl --user start setup-monitor.service&
    '';
  };

  ## Fonts
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

  my.bindings = [
    {
      binding = "super + Return";
      command = "termite";
      description = "New Terminal";
    }
    {
      binding = "super + P";
      command = "mpv-scratchpad-toggle";
      description = "Toggle MPV Scratchpad";
    }
    {
      binding = "super + t";
      command = "toggle-polybar";
      description = "Toggle Polybar";
    }
    {
      binding = "super + i";
      command = "xcolor | xclip -selection clipboard -in";
      description = "Get color";
    }
    {
      binding = "XF86Bluetooth";
      command = "bluetooth-toggle";
      description = "Toggle buetooth";
    }
    {
      binding = "super + shift + x";
      command = "org-capture-frame";
      description = "Emacs Org Capture";
    }
    {
      binding = "super + Escape";
      command = "pkill -USR1 -x sxhkd";
      description = "Reload Shortcuts";
    }
    {
      binding = "super + XF86MonBrightnessDown";
      command = "light -S 0.01";
      description = "Screen brightness: Minimum";
    }
    {
      binding = "super + XF86MonBrightnessUp";
      command = "light -S 100";
      description = "Screen brightness: Maximum";
    }
    {
      binding = "XF86MonBrightnessUp";
      command = "light -A 5";
      description = "Screen brightness: -5%";
    }
    {
      binding = "XF86MonBrightnessDown";
      command = "light -U 5";
      description = "Screen brightness: +5%";
    }
    {
      binding = "{ XF86AudioLowerVolume, super + alt + j }";
      command = "amixer -q set Master 10%- unmute";
      description = "Volume: -10%";
    }
    {
      binding = "XF86MonBrightnessDown";
      command = "light -U 5";
      description = "Screen brightness: Decrease 5%";
    }
    {
      binding = "XF86MonBrightnessDown";
      command = "light -U 5";
      description = "Screen brightness: Decrease 5%";
    }
    {
      binding = "XF86MonBrightnessDown";
      command = "light -U 5";
      description = "Screen brightness: Decrease 5%";
    }
    {
      binding = "XF86MonBrightnessDown";
      command = "light -U 5";
      description = "Screen brightness: Decrease 5%";
    }
    {
      binding = "XF86MonBrightnessDown";
      command = "light -U 5";
      description = "Screen brightness: Decrease 5%";
    }
    {
      binding = "XF86MonBrightnessDown";
      command = "light -U 5";
      description = "Screen brightness: Decrease 5%";
    }
    {
      binding = "XF86MonBrightnessDown";
      command = "light -U 5";
      description = "Screen brightness: Decrease 5%";
    }
    {
      binding = "XF86MonBrightnessDown";
      command = "light -U 5";
      description = "Screen brightness: Decrease 5%";
    }
    {
      binding = "XF86MonBrightnessDown";
      command = "light -U 5";
      description = "Screen brightness: Decrease 5%";
    }
  ];

}
