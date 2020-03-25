{ config, lib, pkgs, ... }:

{
  imports = [
    ../personal.nix   # common settings
    ./hardware-configuration.nix

    <modules/desktop/bspwm.nix>

    <modules/hardware/t490s.nix>
    <modules/hardware/mouse.nix>

    <modules/desktop/sound.nix>
    <modules/desktop/notifications.nix>
    <modules/desktop/lock.nix>
    <modules/browser/chromium.nix>

    <modules/work/meisterlabs.nix>

    <modules/media/default.nix>
    <modules/media/mpv.nix>

    <modules/apps/nautilus.nix>

    # Dev
    <modules/dev/default.nix>
    <modules/editors/emacs.nix>
    <modules/editors/emacs-calctex.nix>
    <modules/editors/vim.nix>
    <modules/dev/node.nix>
    <modules/dev/cpp.nix>
    <modules/dev/docker.nix>
    <modules/dev/reasonml.nix>

    <modules/graphics/gimp.nix>
    <modules/graphics/inkscape.nix>
    <modules/graphics/krita.nix>
    <modules/graphics/screencapture.nix>
    <modules/graphics/xcolor.nix>
    <modules/graphics/optimization.nix>

    # Shell
    # <modules/shell/direnv.nix>
    <modules/shell/gnupg.nix>
    <modules/shell/termite.nix>
    <modules/shell/git.nix>
    <modules/shell/zsh.nix>
    <modules/shell/pass.nix>
    <modules/shell/weechat.nix>

    # Services
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
    # <modules/misc/virtualbox.nix>

    <modules/gaming/emulators.nix>

    # Themes
    <modules/themes/glimpse>
  ];

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
