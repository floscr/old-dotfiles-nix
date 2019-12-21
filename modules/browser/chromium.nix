{ config, lib, pkgs, ... }:

let
  brotab = pkgs.callPackages ../../packages/brotab.nix { };
in {
  environment = {
    sessionVariables = {
      BROWSER = "chromium";
    };

    systemPackages = with pkgs; [
      chromium

      brotab
      (pkgs.writeScriptBin "chromium-private" ''
        #! ${pkgs.bash}/bin/bash
        chromium-browser --incognito "$@"
      '')
    ];
  };

  # Needed for netflix
  nixpkgs.config.chromium = {
    enableWideVine = true;
  };

  programs.chromium = {
    enable = true;
    extensions = [
      # "aomjjhallfgjeglblehebfpbcfeobpgk" # 1Password X
      "gcbommkclmclpchllfjekcdonpmejbdp" # HTTPS Everywhere
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
      "lhaoghhllmiaaagaffababmkdllgfcmc" # Atomic Chrome, edit inputs in emacs
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
      "kbmfpngjjgdllneeigpgjifpgocmfgmb" # Reddit Enhancment Suite
      "ofjfdfaleomlfanfehgblppafkijjhmi" # Georgify - Hacker News Theme
    ];
  };
}
