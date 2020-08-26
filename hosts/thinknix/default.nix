{ config, lib, pkgs, ... }:

{
  imports = [
    ../personal.nix   # common settings
    ./hardware-configuration.nix

    <modules/hardware/monitor.nix>
    <modules/hardware/trackpad.nix>
    <modules/hardware/scanner.nix>

    <modules/work/meisterlabs.nix>

    <modules/misc/home.nix>

    # Themes
    <modules/themes/glimpse>
  ];

  modules = {
    desktop = {
      browsers = {
        default = "chromium";
        chromium.enable = true;
        firefox.enable = true;
      };

      apps = {
        flameshot.enable = true;
        gimp.enable = true;
        gparted.enable = true;
        inkscape.enable = true;
        rofi.enable = true;
        spotify.enable = true;
        xcolor.enable = true;
        transmission.enable = true;
      };

      term = {
        default = "termite";
        termite.enable = true;
      };

      services = {
        keyboardTrackpadDisable.enable = true;
      };

      gaming = {
        steam.enable = true;
      };
    };

    editors = {
      default = "nvim";
      emacs.enable = true;
      emacsCalcTex.enable = true;
      vim.enable = true;
    };

    shell = {
      beancount.enable = true;
      colorOptimization.enable = true;
      direnv.enable = true;
      git.enable = true;
      gnupg.enable = true;
      ncmpcpp.enable = false;
      pass.enable = true;
      weechat.enable = true;
      zsh.enable = true;
      mail.enable = true;
    };

    services = {
      android.enable = true;
      emacsGit.enable = true;
      syncthing.enable = true;
      virtualbox.enable = true;
      suspendFix.enable = true;
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

  networking.extraHosts = ''
    # Alias localhost to l
    127.0.0.1 l
  '';

  # Automatically log in since the disk is encrypted with a password anyway
  services.xserver.displayManager.lightdm.autoLogin.enable = true;
  services.xserver.displayManager.lightdm.autoLogin.user = config.my.username;

  services.wg-quicker = {
    available = true;
    setups = {
      "ch" = builtins.toString "/etc/dotfiles-private/mullvad/ch5.conf";
      "us" = builtins.toString "/etc/dotfiles-private/mullvad/us1.conf";
    };
  };
  # Start wg-quicker commands without sudo from rofi
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

  # Monitor backlight control
  programs.light.enable = true;
}
