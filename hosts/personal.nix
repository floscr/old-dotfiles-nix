{ config, lib, pkgs, ... }:

{
  ## File Handling and file systems
  environment.systemPackages = with pkgs; [
    # Use nix-run to test applications instead of littering you base
    nix-bundle

    # Support for more filesystems
    exfat
    exfat-utils
    ntfs3g
    hfsprogs
  ];
  boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];

  # Nothing in /tmp should survive a reboot
  boot.tmpOnTmpfs = true;

  ## Bootloader
  boot.loader = {
    timeout = 1;
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      # Fix a security hole in place for backwards compatibility. See desc in
      # nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
      editor = false;
      # Limit number of generations to display in boot menu
      configurationLimit = 10;
    };
  };

  my.home.xdg.configFile."user-dirs.dirs".text = ''
    XDG_DESKTOP_DIR="$HOME/Desktop"
    XDG_DOWNLOAD_DIR="$HOME/Downloads"
    XDG_DOCUMENTS_DIR="$HOME/Documents"
    XDG_MUSIC_DIR="$HOME/Media/Music"
    XDG_PICTURES_DIR="$HOME/Media/Images"
    XDG_VIDEOS_DIR="$HOME/Media/Videos"
    XDG_TEMPLATES_DIR="$HOME/Documents/Templates"
  '';
  # Clean up leftovers, as much as we can
  system.activationScripts.clearHome = ''
    pushd /home/${config.my.username}
    rm -rf .compose-cache .nv .pki .dbus .fehbg
    [ -s .xsession-errors ] || rm -f .xsession-errors*
    popd
  '';
}
