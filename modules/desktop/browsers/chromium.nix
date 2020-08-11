{ config, options, lib, pkgs, ... }:
with lib;
{
  options.modules.desktop.browsers.chromium = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.browsers.chromium.enable {
    my.packages = with pkgs; [
      chromium

      (pkgs.writeScriptBin "launch-chrome" ''
        #! ${pkgs.bash}/bin/bash
        # start chromium depending on which display is connected

        export DEFAULT_ARGS="--enable-native-notifications --restore-last-session"

        if [[ $(xrandr | grep "^eDP1 connected primary") ]]; then
          chromium-browser $DEFAULT_ARGS --force-device-scale-factor=1.2
        else
          chromium-browser $DEFAULT_ARGS --force-device-scale-factor=1.5
        fi
      '')
      (pkgs.writeScriptBin "chromium-private" ''
        #! ${pkgs.bash}/bin/bash
        chromium-browser --incognito "$@"
      '')
    ];

    my.bindings = [
      {
        description = "Chromium";
        categories = "Browser";
        command = "launch-chrome";
      }
      # {
      #   description = "Private Chromium";
      #   categories = "Browser";
      #   command = "chromium-private";
      # }
    ];

    # Needed for netflix
    nixpkgs.config.chromium = {
      enableWideVine = true;
    };

    # Extensions
    programs.chromium = {
      enable = true;
      defaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
      defaultSearchProviderSuggestURL = "https://ac.duckduckgo.com/ac/?q={searchTerms}&type=list";
      extensions = [
        "gcbommkclmclpchllfjekcdonpmejbdp" # HTTPS Everywhere
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
        "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
        "lhaoghhllmiaaagaffababmkdllgfcmc" # Atomic Chrome, edit inputs in emacs
        "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
        "kbmfpngjjgdllneeigpgjifpgocmfgmb" # Reddit Enhancment Suite
        "ofjfdfaleomlfanfehgblppafkijjhmi" # Georgify - Hacker News Theme
        "gbmdgpbipfallnflgajpaliibnhdgobh" # JSON Viewer
        "ndiaggkadcioihmhghipjmgfeamgjeoi" # Add URL to window title
        "fipfgiejfpcdacpjepkohdlnjonchnal" # Tab Shortcuts
      ];
    };
  };
}
