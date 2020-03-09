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

  environment = {
    systemPackages = with pkgs; [my.cached-nix-shell];
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
