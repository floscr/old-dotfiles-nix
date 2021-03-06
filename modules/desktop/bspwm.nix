{ config, lib, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./sound.nix
    ./services/default.nix
    ./term/default.nix
  ];

  modules.theme.onReload.bspwm = ''
    ${pkgs.bspwm}/bin/bspc wm -r
  '';

  environment = {
    systemPackages = with pkgs; [
      lightdm
      sxhkd
    ];
  };


  services = {
    xserver = {
      desktopManager.xterm.enable = false;
      windowManager.bspwm.enable = true;
      displayManager.defaultSession = "none+bspwm";
    };
  };

  my.bindings = [
    {
      binding = "super + grave";
      command = "bspc node -f last";
      description = "Switch to previous window";
    }
    {
      binding = "super + comma";
      command = "nimx scratchTerminal";
      description = "Switch to previous window";
    }
    {
      binding = "super + Tab";
      command = "bspc desktop -f last";
      description = "Switch to previous desktop";
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
      command = "bspc {desktop -f,node -d} \^{1-9,10}";
      description = "Switch to desktop";
    }
    {
      binding = "super + {h,j,k,l}";
      command = "/etc/dotfiles/bin/bspc/focus {west,south,north,east}";
      description = "Focus/Swap the node in the given direction";
    }
    {
      binding = "super + shift + {h,j,k,l}";
      command = "/etc/dotfiles/bin/bspc/swap {west,south,north,east}";
      description = "Focus/Swap the node in the given direction";
    }
    {
      binding = "super + {_,ctrl + }f";
      command = "bspc node -t ~{floating,fullscreen}";
      description = "Toggle floating/fullscreen";
    }
    {
      binding = "super + shift + apostrophe";
      command = "bspc node -g sticky";
      description = "Toggle sticky";
    }
    {
      binding = "super + shift + f";
      command = "/etc/dotfiles/bin/bspc/toggle_desktop_mode";
      description = "Toggle Desktop Mode";
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
    {
      binding = "super + ctrl + {h,j,k,l}";
      description = "Resize Window";
      command = "/etc/dotfiles/bin/bspc/resize {west,south,north,east}";
    }
    {
      description = "Layout: Tall";
      command = "/etc/dotfiles/submodules/bsp-layout/src/layout.sh set tall";
    }
    {
      description = "Layout: Reverse Tall";
      command = "/etc/dotfiles/submodules/bsp-layout/src/layout.sh set rtall";
    }
    {
      description = "Layout: Wide";
      command = "/etc/dotfiles/submodules/bsp-layout/src/layout.sh set wide";
    }
    {
      description = "Layout: Reverse Wide";
      command = "/etc/dotfiles/submodules/bsp-layout/src/layout.sh set rwide";
    }
    {
      description = "Layout: Grid";
      command = "/etc/dotfiles/submodules/bsp-layout/src/layout.sh set grid";
    }
    {
      description = "Layout: Reverse Grid";
      command = "/etc/dotfiles/submodules/bsp-layout/src/layout.sh set rgrid";
    }
    {
      description = "Layout: Balance Windows";
      command = "/etc/dotfiles/submodules/bsp-layout/src/layout.sh set even";
    }
    {
      description = "Layout: Default (tiles)";
      command = "/etc/dotfiles/submodules/bsp-layout/src/layout.sh set tiled";
    }
    {
      description = "Layout: Reset";
      command = "/etc/dotfiles/submodules/bsp-layout/src/layout.sh remove";
    }
    {
      description = "Layout: Cycle";
      command = "/etc/dotfiles/submodules/bsp-layout/src/layout.sh cycle";
    }
  ];

  my.home.xdg.configFile = {
    "bspwm" = { source = <config/bspwm>; recursive = true; };
    "sxhkd/sxhkdrc".text = ''
        # turn off screen
        super + BackSpace
          zzz
        # sleep
        super + shift + BackSpace
          zzz -f
        # screencast region to mp4
        super + alt + s
          scrrec -s ~/Media/Screenrecording/$(date +%F-%T).mp4
        # screencast region to gif
        super + ctrl + s
          scrrec -s ~/Media/Screenrecording/$(date +%F-%T).gif
    '';
  };
}
