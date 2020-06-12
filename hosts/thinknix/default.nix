{ config, lib, pkgs, ... }:

{
  imports = [
    ../personal.nix   # common settings
    ./hardware-configuration.nix

    <modules/hardware/monitor.nix>
    <modules/hardware/mouse.nix>
    <modules/hardware/scanner.nix>

    <modules/work/meisterlabs.nix>

    <modules/graphics/gimp.nix>
    <modules/graphics/inkscape.nix>
    <modules/graphics/krita.nix>
    <modules/graphics/screencapture.nix>
    <modules/graphics/xcolor.nix>
    <modules/graphics/optimization.nix>

    # Shell
    # <modules/shell/direnv.nix>
    <modules/shell/gnupg.nix>
    <modules/shell/git.nix>
    <modules/shell/zsh.nix>
    <modules/shell/pass.nix>
    <modules/shell/weechat.nix>

    # Services
    <modules/services/mpd.nix>
    <modules/services/syncthing.nix>
    <modules/services/greenclip.nix>
    <modules/services/battery-notifier.nix>
    <modules/services/wireguard.nix>
    <modules/services/emacsGit.nix>
    <modules/services/emacs-caldav-sync.nix>

    <modules/misc/disk-management.nix>
    <modules/misc/android.nix>
    <modules/misc/keyboard.nix>
    <modules/misc/home.nix>
    <modules/misc/virtualbox.nix>
    <modules/misc/transmission.nix>

    # Themes
    <modules/themes/glimpse>
  ];

  my.packages = with pkgs; [
    beancount
  ];

  modules = {
    desktop = {
      browsers.default = "chromium";
      browsers.chromium.enable = true;
      browsers.firefox.enable = true;

      apps.rofi.enable = true;
      apps.spotify.enable = true;

      term.default = "termite";
      term.termite.enable = true;

      services.wallpaper.enable = false;
    };

    services = {
      greenclip.enable = true;
    };

    editors = {
      default = "nvim";
      emacs.enable = true;
      emacsCalcTex.enable = true;
      vim.enable = true;
    };

    dev = {
      docker.enable = true;
      mysql.enable = true;
      node.enable = true;
      reasonml.enable = true;
    };

    media = {
      youtube-dl.enable = true;
      ncmpcpp.enable = true;
    };
  };

  time.timeZone = "Europe/Vienna";

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  services.wg-quicker = {
    available = true;
    setups = {
      "ch" = builtins.toString "/etc/dotfiles-private/mullvad/ch1.conf";
      "us" = builtins.toString "/etc/dotfiles-private/mullvad/us1.conf";
    };
  };
  security.sudo.enable = true;
  security.sudo.extraConfig = ''
    %wheel      ALL=(ALL:ALL) NOPASSWD: ${pkgs.systemd}/bin/systemctl start wg-quicker-ch.service
    %wheel      ALL=(ALL:ALL) NOPASSWD: ${pkgs.systemd}/bin/systemctl stop wg-quicker-ch.service
  '';

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fontconfig = {
      dpi = 180;
      defaultFonts.monospace = [ "Iosevka" ];
      useEmbeddedBitmaps = true;
      # ultimate = {
      #   enable = true;
      #   substitutions = "combi";
      # };
    };
    fonts = with pkgs; [
      fira-code
      fira-code-symbols
      font-awesome_5
      iosevka
      noto-fonts
      noto-fonts-cjk
      siji
      symbola
    ];
  };

  # Notify on low battery
  services.batteryNotifier.enable = true;

  # Networking
  networking.networkmanager.enable = true;

  # Printing
  services.printing.enable = true;

  # Monitor backlight control
  programs.light.enable = true;
}
