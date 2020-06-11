# default.nix --- my dotfile bootstrapper

device:
{ config, pkgs, options, lib, ...}:
{
  networking.hostName = lib.mkDefault device;

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
  
    gnumake               # for our own makefile
    my.cached-nix-shell   # for instant nix-shell scripts
  ];

  environment.shellAliases = {
    nix-env = "NIXPKGS_ALLOW_UNFREE=1 nix-env";
    ngc = "nix-collect-garbage -d && sudo nix-collect-garbage -d";
    nre = "(cd /etc/dotfiles; make switch)";
    nix-installed = "nix-instantiate --strict --json --eval -E 'builtins.map (p: p.name) (import <nixpkgs/nixos> {}).config.environment.systemPackages' | nix run nixpkgs.jq -c jq -r '.[]' | sort -u";
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

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
