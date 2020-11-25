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
      home.xdg.mimeApps = {
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
      home.xdg.configFile = {
        ".aspell.conf".text = ''
          dict-dir $HOME/.nix-profile/lib/aspell
          master en_US
          extra-dicts en-computers.rws
          add-extra-dicts en_US-science.rws
        '';
      };

      bindings = [
        {
          description = "Emacs";
          categories = "Editor";
          command = "emacs";
        }
      ];

      packages = with pkgs; [
        ## Doom dependencies
        git
        (ripgrep.override {withPCRE2 = true;})

        # Emacs compiled with packages
        ((emacsPackagesNgGen emacsUnstable).emacsWithPackages (epkgs: [
          # vterm
          epkgs.emacs-libvterm
        ]))

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

        # vterm
        cmake

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
