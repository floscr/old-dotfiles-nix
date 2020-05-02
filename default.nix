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
  # Add custom packages & unstable channel, so they can be accessed via pkgs.*
  nixpkgs.overlays = import ./packages;
  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [my.cached-nix-shell];
    shellAliases = {
      nix-env = "NIXPKGS_ALLOW_UNFREE=1 nix-env";
      ngc = "nix-collect-garbage -d && sudo nix-collect-garbage -d";
      nre = "(cd /etc/dotfiles; make switch)";
      nix-installed = "nix-instantiate --strict --json --eval -E 'builtins.map (p: p.name) (import <nixpkgs/nixos> {}).config.environment.systemPackages' | nix run nixpkgs.jq -c jq -r '.[]' | sort -u";
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
