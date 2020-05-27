# Emacs Doom is my main driver.
# https://github.com/hlissner/doom-emacs.
# This module sets it up to meet my particular Doomy needs.

{ config, options, lib, pkgs, ... }:
with lib;
{
  options.modules.editors.emacs = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.editors.emacs.enable {
    my = {
      home.xdg.configFile = {
        ".aspell.conf".text = ''
          dict-dir $HOME/.nix-profile/lib/aspell
          master en_US
          extra-dicts en-computers.rws
          add-extra-dicts en_US-science.rws
        '';
      };

      packages = with pkgs; [
        ## Doom dependencies
        emacsUnstable
        git
        (ripgrep.override {withPCRE2 = true;})

        ## Optional dependencies
        editorconfig-core-c # per-project style config
        fd                  # faster projectile indexing
        gnutls              # for TLS connectivity
        imagemagickBig      # for image-dired
        (lib.mkIf (config.programs.gnupg.agent.enable)
          pinentry_emacs)   # in-emacs gnupg prompts
        zstd                # for undo-tree compression

        (lib.mkIf (config.programs.gnupg.agent.enable)
          pinentry_emacs)   # in-emacs gnupg prompts

        # Convert stuff
        pandoc

        ## Module dependencies
        # :checkers spell
        (aspellWithDicts (dicts: with dicts; [
          de
          en
          en-computers
          en-science
        ]))
        # :checkers grammar
        languagetool
        # :tools lookup
        sqlite gcc
        # :lang cc
        ccls
        # :lang javascript
        nodePackages.javascript-typescript-langserver
        nodePackages.indium
        nodePackages.eslint_d
        # :private system
        wmctrl
        # Emacsclient as the default file explorer
        (makeDesktopItem {
          terminal = "False";
          name = "emacs-dired";
          genericName = "Text editor";
          desktopName = "Emacs Dired";
          mimeType = "inode/directory;application/x-directory";
          icon = "emacs";
          exec = "${emacsUnstable}/bin/emacsclient -c";
          categories = "Development";
          type = "Application";
        })
      ];

      env.PATH = [ "$HOME/.emacs.d/bin" ];
      zsh.rc = lib.readFile <config/emacs/aliases.zsh>;
    };
    fonts.fonts = with pkgs; [
      emacs-all-the-icons-fonts
      overpass
    ];
  };
}
