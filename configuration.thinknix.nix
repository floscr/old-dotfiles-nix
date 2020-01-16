{ config, lib, pkgs, ... }:

let nixos-hardware = builtins.fetchTarball https://github.com/NixOS/nixos-hardware/archive/master.tar.gz;

in {
  imports = [
    ./.  # import common settings

    # Hardware specific
    "${nixos-hardware}/common/cpu/intel"
    "${nixos-hardware}/common/pc/laptop/acpi_call.nix"

    ./modules/hardware/t490s.nix
    ./modules/hardware/mouse.nix

    # Desktoop Ui
    ./modules/desktop/bspwm.nix
    # ./modules/desktop/autorandr.nix
    ./modules/desktop/sound.nix
    ./modules/desktop/notifications.nix
    ./modules/browser/chromium.nix

    ./modules/work/meisterlabs.nix

    ./modules/media/default.nix
    ./modules/media/mpv.nix

    ./modules/apps/nautilus.nix

    # Dev
    ./modules/dev/default.nix
    ./modules/editors/emacs.nix
    ./modules/editors/vim.nix
    ./modules/dev/node.nix
    ./modules/dev/cpp.nix
    ./modules/dev/docker.nix
    ./modules/dev/reasonml.nix
    ./modules/dev/rust.nix

    ./modules/graphics/gimp.nix
    ./modules/graphics/inkscape.nix
    ./modules/graphics/krita.nix
    ./modules/graphics/screencapture.nix
    ./modules/graphics/xcolor.nix
    ./modules/graphics/optimization.nix

    # Shell
    # ./modules/shell/direnv.nix
    ./modules/shell/gnupg.nix
    ./modules/shell/termite.nix
    ./modules/shell/git.nix
    ./modules/shell/zsh.nix
    ./modules/shell/pass.nix
    ./modules/shell/weechat.nix

    # Services
    ./modules/services/syncthing.nix
    ./modules/services/greenclip.nix
    ./modules/services/battery-notifier.nix
    ./modules/services/wireguard.nix

    ./modules/misc/disk-management.nix
    ./modules/misc/android.nix
    ./modules/misc/keyboard.nix
    ./modules/misc/home.nix
    ./modules/misc/virtualbox.nix

    ./modules/gaming/emulators.nix

    # Themes
    ./themes/glimpse
  ] ++ lib.optional (builtins.pathExists ../dotfiles-private/private.nix) ../dotfiles-private/private.nix;

  nixpkgs.overlays = [
    (import ./overlays/chromium.nix)
  ];

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  services.wg-quicker = {
    available = true;
    setups = {
      "ch" = builtins.toString ../dotfiles-private/mullvad/ch1.conf;
    };
  };

  fonts = {
    fontconfig = {
      dpi = 180;
      enable = true;
      antialias = true;
      defaultFonts.monospace = [ "Iosevka" ];
      allowBitmaps = true;
      useEmbeddedBitmaps = true;
      ultimate = {
        enable = true;
        substitutions = "combi";
      };
    };
    fonts = with pkgs; [
      fira-code-symbols
      iosevka
      noto-fonts
      symbola
      noto-fonts-cjk
      font-awesome_5
    ];
  };

  # Notify on low battery
  services.batteryNotifier.enable = true;

  # Networking
  networking.hostName = "thinknix";
  networking.networkmanager.enable = true;

  # Printing
  services.printing.enable = true;

  # Monitor backlight control
  programs.light.enable = true;
}
