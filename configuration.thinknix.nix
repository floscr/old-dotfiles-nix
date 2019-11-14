{ config, lib, pkgs, ... }:

let nixos-hardware = builtins.fetchTarball https://github.com/NixOS/nixos-hardware/archive/master.tar.gz;

in {
  imports = [
    ./.  # import common settings

    # Hardware specific
    "${nixos-hardware}/common/cpu/intel"
    "${nixos-hardware}/common/pc/laptop/acpi_call.nix"

    # Desktoop Ui
    ./modules/desktop/bspwm.nix
    # ./modules/desktop/autorandr.nix
    ./modules/desktop/sound.nix
    ./modules/desktop/notifications.nix
    ./modules/browser/chromium.nix

    # Dev
    ./modules/editors/emacs.nix
    ./modules/dev/node.nix
    ./modules/dev/cpp.nix
    ./modules/dev/default.nix
    ./modules/dev/docker.nix

    ./modules/graphics/gimp.nix
    ./modules/graphics/krita.nix
    ./modules/graphics/screencapture.nix

    # Shell
    # ./modules/shell/direnv.nix
    ./modules/shell/gnupg.nix
    ./modules/shell/termite.nix
    ./modules/shell/git.nix
    ./modules/shell/zsh.nix
    ./modules/shell/pass.nix

    # Services
    ./modules/services/syncthing.nix
    ./modules/services/greenclip.nix

    ./modules/misc/keyboard.nix
    ./modules/misc/throttled.nix

    # Themes
    ./themes/glimpse
  ];

  nixpkgs.overlays = [
    (import ./overlays/chromium.nix)
  ];

  # Encrypted Disk
  boot.initrd.luks.devices = [{
    name = "root";
    device = "/dev/nvme0n1p2";
    preLVM = true;
  }];

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
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

  # Networking
  networking.hostName = "thinknix";
  networking.networkmanager.enable = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" ];
  boot.kernelModules = [ "kvm-intel" ];

  services.thermald = {
    enable = true;
    configFile = <config/thermald/thermal-conf.xml>;
  };
  home-manager.users.floscr.xdg.configFile = {
    "thermald/thermal-conf.xml".source = <config/thermald/thermal-conf.xml>;
  };

  # environment.systemPackages = [ unstable.throttled ];
  services.throttled.enable = true;

  # Printing
  services.printing.enable = true;

  # services.undervolt.enable = true;
  # services.undervolt.coreOffset= "-110";
  # services.undervolt.temp= "95";

  # Monitor backlight control
  programs.light.enable = true;
}
