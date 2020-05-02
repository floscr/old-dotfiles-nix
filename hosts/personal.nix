{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Use nix-run to test applications instead of littering you base
    nix-bundle

    # Support for more filesystems
    exfat
    ntfs3g
    hfsprogs
  ];
  boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];

  # Nothing in /tmp should survive a reboot
  boot.tmpOnTmpfs = true;
  # Use simple bootloader; I prefer the on-demand BIOs boot menu
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  ### A tidy $HOME is a tidy mind
  # Obey XDG conventions;
  my.home.xdg.enable = true;
  environment.variables = {
    # These are the defaults, but some applications are buggy when these lack
    # explicit values.
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_BIN_HOME    = "$HOME/.local/bin";
    DOTFILES = "$HOME/.dotfiles";
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
  my.home.xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/x-directory" = "emacs-dired.desktop";
      "inode/directory" = "emacs-dired.desktop";
      "text/english" = "emacs.desktop";
      "text/plain" = "emacs.desktop";
      "text/x-c" = "emacs.desktop";
      "text/x-c++" = "emacs.desktop";
      "text/x-c++hdr" = "emacs.desktop";
      "text/x-c++src" = "emacs.desktop";
      "text/x-chdr" = "emacs.desktop";
      "text/x-csrc" = "emacs.desktop";
      "text/x-java" = "emacs.desktop";
      "text/x-makefile" = "emacs.desktop";
      "text/x-moc" = "emacs.desktop";
      "text/x-pascal" = "emacs.desktop";
      "text/x-tcl" = "emacs.desktop";
      "text/x-tex" = "emacs.desktop";
    };
  };

  # Conform more programs to XDG conventions. The rest are handled by their
  # respective modules.
  my.env = {
    __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    HISTFILE = "$XDG_DATA_HOME/bash/history";
    INPUTRC = "$XDG_CACHE_HOME/readline/inputrc";
    LESSHISTFILE = "$XDG_CACHE_HOME/lesshst";
    WGETRC = "$XDG_CACHE_HOME/wgetrc";
  };

  # Clean up leftovers, as much as we can
  system.activationScripts.clearHome = ''
    pushd /home/${config.my.username}
    rm -rf .compose-cache .nv .pki .dbus .fehbg
    [ -s .xsession-errors ] || rm -f .xsession-errors*
    popd
  '';

}
