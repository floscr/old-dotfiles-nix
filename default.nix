device:
{ config, pkgs, options, lib, ...}:

with lib;
{
  ## Networking
  networking.hostName = lib.mkDefault device;
  networking.networkmanager.enable = true;

  imports = [
    ./modules
    "${./hosts}/${device}"
  ] ++ lib.optional (builtins.pathExists /etc/dotfiles-private/private.nix) /etc/dotfiles-private/private.nix;

  nix = {
    trustedUsers = [ "root" "@wheel" ];
    nixPath = options.nix.nixPath.default ++ [
      "bin=/etc/dotfiles/bin"
      "nimbin=/etc/dotfiles/nimbin"
      "config=/etc/dotfiles/config"
      "modules=/etc/dotfiles/modules"
    ];
    autoOptimiseStore = true;
    useSandbox = true;
  };

  nixpkgs.overlays = import ./packages;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    coreutils
    git
    gnumake
    killall
    unstable.cached-nix-shell
    vim
    wget
  ];

  environment.shellAliases = {
    nix-env = "NIXPKGS_ALLOW_UNFREE=1 nix-env";
    ngc = "nix-collect-garbage -d && sudo nix-collect-garbage -d";
    nre = "(cd /etc/dotfiles; make switch)";
    nix-installed = "nix-env --query";
    nu = "sudo nix-env --uninstall";
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.configurationLimit = 10;
    systemd-boot.enable = mkDefault true;
    timeout = 1;
  };

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
  my.home.xdg.configFile = {
    "wgetrc".source = <config/wget/wgetrc>;
  };
}
