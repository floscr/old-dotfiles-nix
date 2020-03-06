# default.nix --- my dotfile bootstrapper

device:
{ config, pkgs, options, lib, ...}:
{
  networking.hostName = lib.mkDefault device;

  imports = [
    ./options.nix
    "${./hosts}/${device}"
  ] ++ lib.optional (builtins.pathExists /etc/dotfiles-private/private.nix) /etc/dotfiles-private/private.nix;

  ### NixOS
  nix.autoOptimiseStore = true;
  nix.trustedUsers = [ "root" "@wheel" ];
  nix.nixPath = options.nix.nixPath.default ++ [
    # So we can use absolute import paths
    "bin=/etc/dotfiles/bin"
    "config=/etc/dotfiles/config"
    "modules=/etc/dotfiles/modules"
  ];
  # ...but we still need to set nixpkgs.overlays to make them visible to the
  # rebuild process, however...
  nixpkgs.overlays = import ./overlays.nix;
  nixpkgs.config.allowUnfree = true;

  # Nothing in /tmp should survive a reboot
  boot.cleanTmpDir = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];

  environment = {
    systemPackages = with pkgs; [my.cached-nix-shell];
    variables = {
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_BIN_HOME = "$HOME/.local/bin";
      DOTFILES = "$HOME/.dotfiles";
    };
    shellAliases = {
      q = "exit";
      nix-env = "NIXPKGS_ALLOW_UNFREE=1 nix-env";
      ne = "nix-env";
      nu = "sudo nix-channel --update && sudo nixos-rebuild -I config=$HOME/.dotfiles/config switch";
      ngc = "nix-collect-garbage -d && sudo nix-collect-garbage -d";
      nre = "sudo nixos-rebuild switch -I config=/etc/dotfiles/config -I modules=/etc/dotfiles/modules";
      ns = "nix-env -qaP .\*$1.\*";
      sudo = "sudo ";
    };
  };

  sound.enable = true;

  services.xserver = {
    enable = true;
    autorun = true;

    desktopManager.xterm.enable = false;
    windowManager.bspwm.enable = true;
    displayManager.lightdm.enable = true;

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

  home-manager.users.floscr = {
    xdg.enable = true;
    home.file."bin" = {
      source = ./bin;
      recursive = true;
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?
}
