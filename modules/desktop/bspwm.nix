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

  my.home.xdg.configFile = {
    "bspwm" = { source = <config/bspwm>; recursive = true; };
    "sxhkd/sxhkdrc".text = ''
F12
	monitor-hotplug

super + e
	emacs-atomic-edit-here

super + Return
	termite

super + P
	mpv-scratchpad-toggle


super + bracket{left,right}
  desk=`bspc query -D -d focused`; \
  bspc desktop -m {prev,next}; \
  bspc monitor -f {prev,next}; \
  bspc desktop -f $desk

super + shift + f
	/etc/dotfiles/bin/bspc/toggle_desktop_mode


super + t
	toggle-polybar

super + apostrophe
	rofi-pass -dmenu -theme theme/passmenu.rasi

XF86Bluetooth
	bluetooth-toggle



# Balance tree
super + b
	bspc node @/ -B

# Balance brother node. If you do this on biggest window of the desktop, it usually means balancing all windows with except the biggest.
super + alt + b
	bspc node @brother -B

super + @space
	~/.config/rofi/modules/main

super + {_,shift + }w
	bspc node -{c,k}

super + shift + x
	org-capture-frame

super + shift + Tab
	/etc/dotfiles/bin/rofi/app_switch

super + {grave,Tab}
	bspc {node,desktop} -f last

super + d
	rofi -show

super + {_,shift +}{1-9,0}
	bspc {desktop -f,node -d} {1-9,10}

# focus/swap the node in the given direction
super + {_,ctrl +}{h,j,k,l}
	 /etc/dotfiles/bin/bspc/focus {_,-m }{west,south,north,east}

super + shift + {_,ctrl +}{h,j,k,l}
	/etc/dotfiles/bin/bspc/swap {_,-m }{west,south,north,east}

# Toggle floating/fullscreen
super + {_,ctrl + }f
	bspc node -t ~{floating,fullscreen}

# sxhkd config reload
super + Escape
	pkill -USR1 -x sxhkd

super + XF86MonBrightnessDown
	light -S 0.01
super + XF86MonBrightnessUp
	light -S 100
XF86MonBrightnessUp
	light -A 5
XF86MonBrightnessDown
	light -U 5


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

# Circulate the leaves of the tree
# super + {_,shift + }x
# 	bspc node @/ --circulate {backward,forward}

# flip
super + ctrl + {_,shift + }v
	bspc node @/ --flip {vertical,horizontal}

# super + shift + {_,ctrl +}{h,j,k,l}
# 	/etc/dotfiles/bin/bspc/swap {_,-m }{west,south,north,east}

super + ctrl + h
	bspc node @east -r +100

# super + ctrl + {h,j,k,l}
# 	bspc node {@west,@south,@north,@east} -r +100

'';
  };
}
