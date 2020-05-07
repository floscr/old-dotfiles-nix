{ config, lib, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./sound.nix
    ./services/lock.nix
    ./services/notifications.nix
    ./services/polybar.nix
    ./services/redshift.nix
    ./services/wallpaper.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      lightdm
      sxhkd
    ];
  };

  services = {
    xserver = {
      windowManager.default = "bspwm";
      windowManager.bspwm.enable = true;
    };
  };

  my.bindings = [
    {
      binding = "super + shift + v";
      command = "/etc/dotfiles/bin/bspc/toggle_desktop_mode";
      description = "Toggle Floating Desktop Mode";
    }
    {
      binding = "super + grave";
      command = "bspc node -f last";
      description = "Switch to previous window";
    }
    {
      binding = "super + Tab";
      command = "bspc desktop -f last";
      description = "Switch to previous desktop";
    }
    {
      binding = "super + shift + v";
      command = "/etc/dotfiles/bin/bspc/toggle_desktop_mode";
      description = "Toggle Floating Desktop Mode";
    }
    {
      binding = "super + w";
      command = "bspc node --close";
      description = "Close window";
    }
    {
      binding = "super + shift + w";
      command = "bspc node --kill";
      description = "Kill process";
    }
    {
      binding = "super + {_,shift +}{1-9,0}";
      command = "bspc {desktop -f,node -d} {1-9,10}";
      description = "Switch to desktop";
    }
    {
      binding = "super + {_,ctrl +}{h,j,k,l}";
      command = "/etc/dotfiles/bin/bspc/focus {_,-m }{west,south,north,east}";
      description = "Focus/Swap the node in the given direction";
    }
    {
      binding = "super + shift + {_,ctrl +}{h,j,k,l}";
      command = "/etc/dotfiles/bin/bspc/swap {_,-m }{west,south,north,east}";
      description = "Focus/Swap the node in the given direction";
    }
    {
      binding = "super + {_,ctrl + }f";
      command = "bspc node -t ~{floating,fullscreen}";
      description = "Toggle floating/fullscreen";
    }
    {
      binding = "super + ctrl + {_,shift + }v";
      command = "bspc node @/ --flip {vertical,horizontal}";
      description = "Flip Splits";
    }
    {
      binding = "super + alt + b";
      command = "bspc node @brother -B";
      description = "Flip Splits";
    }
  ];

  my.home.xdg.configFile = {
    "bspwm" = { source = <config/bspwm>; recursive = true; };
    "sxhkd/sxhkdrc".text = ''

{ XF86AudioLowerVolume, super + alt + j }
	amixer -q set Master 10%- unmute
{ XF86AudioRaiseVolume, super + alt + k }
	amixer -q set Master 10%+ unmute
{ XF86AudioPlay, super + alt + p }
	playerctl play-pause
{ XF86AudioNext, super + alt + l }
	playerctl next
{ XF86AudioPrev, super + alt + h }
	playerctl previous
{ XF86AudioMute, super + alt + m }
	amixer -q set Master toggle
super + alt + c
	amixer set Capture toggle


# turn off screen
super + BackSpace
	zzz
# sleep
super + shift + BackSpace
	zzz -f

# Screenshot
super + shift + s
	flameshot gui

# screencast region to mp4
super + alt + s
	scrrec -s ~/Media/Screenrecording/$(date +%F-%T).mp4
# screencast region to gif
super + ctrl + s
	scrrec -s ~/Media/Screenrecording/$(date +%F-%T).gif

'';
  };
}
