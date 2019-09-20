{ config, pkgs, ...}:

{
  imports = [
    <home-manager/nixos>
  ];

  # Nothing in /tmp should survive a reboot
  boot.cleanTmpDir = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix = {
    autoOptimiseStore = true;
    trustedUsers = [ "root" "@wheel" ];
  };
  nixpkgs.config.allowUnfree = true;

  # Cpu throttling
  services.thermald.enable = true;

  environment = {
    systemPackages = with pkgs; [
    bc
    coreutils
    tree
    firefox
    git
    htop
    killall
    networkmanager
    networkmanagerapplet
    rofi
    unzip
    vim
    wget
    (ripgrep.override { withPCRE2 = true; })
    ];
    variables = {
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_BIN_HOME = "$HOME/.local/bin";
      DOTFILES = "$HOME/.dotfiles";
      # GTK2_RC_FILES = "$HOME/.config/gtk-2.0/gtkrc";
    };
    shellAliases = {
      q = "exit";
      clr = "clear";
      sudo = "sudo ";
    };
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";
  services.xserver.windowManager.i3.enable = true;
  services.xserver.autorun = true;

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  users.users.floscr = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "video" "networkmanager" ];
    shell = pkgs.zsh;
  };

  nix.nixPath = options.nix.nixPath.default ++ [ "config=${./config}" ];
  home-manager.users.floscr = {
    xdg.enable = true;
    home.file."bin" = {
      source = ./bin;
      recursive = true;
    };
  };

  # programs.home-manager.enable = true;
  # programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;

  # home-manager.users.floscr = {
  #   programs.zsh.enable = true;
  # };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?
}
