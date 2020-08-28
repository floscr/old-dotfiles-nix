# default.nix --- my dotfile bootstrapper

device:
{ config, pkgs, options, lib, ...}:
{
  ## Networking
  networking.hostName = lib.mkDefault device;
  networking.networkmanager.enable = true;

  imports = [
    ./modules
    "${./hosts}/${device}"
  ] ++ lib.optional (builtins.pathExists /etc/dotfiles-private/private.nix) /etc/dotfiles-private/private.nix;

  ### NixOS
  nix.autoOptimiseStore = true;
  nix.trustedUsers = [ "root" "@wheel" ];
  nix.nixPath = options.nix.nixPath.default ++ [
    # So we can use absolute import paths
    "bin=/etc/dotfiles/bin"
    "nimbin=/etc/dotfiles/nimbin"
    "config=/etc/dotfiles/config"
    "modules=/etc/dotfiles/modules"
  ];

  # Add custom packages & unstable channel, so they can be accessed via pkgs.*
  nixpkgs.overlays = import ./packages;
  nixpkgs.config.allowUnfree = true;

  # These are the things I want installed on all my systems
  environment.systemPackages = with pkgs; [
    coreutils
    git
    killall
    networkmanager
    networkmanagerapplet
    unzip
    unrar
    vim
    wget
    jq
  
    gnumake # for our own makefile
    unstable.cached-nix-shell # for instant nix-shell scripts
  ];

  environment.shellAliases = {
    nix-env = "NIXPKGS_ALLOW_UNFREE=1 nix-env";
    ngc = "nix-collect-garbage -d && sudo nix-collect-garbage -d";
    nre = "(cd /etc/dotfiles; make switch)";
    nix-installed = "nix-env --query";
    nu = "sudo nix-env --uninstall";
  };

  ### My user settings
  my.user = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "video"
      "networkmanager"
    ];
    shell = pkgs.zsh;
  };
}
