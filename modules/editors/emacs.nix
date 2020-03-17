{ config, lib, pkgs, ... }:

{
  my.packages = with pkgs; [
    ## Doom dependencies
    emacsGit
    git
    (ripgrep.override {withPCRE2 = true;})

    ## Optional dependencies
    editorconfig-core-c # per-project style config
    fd                  # faster projectile indexing
    gnutls              # for TLS connectivity
    imagemagick         # for image-dired
    (lib.mkIf (config.programs.gnupg.agent.enable)
      pinentry_emacs)   # in-emacs gnupg prompts
    zstd                # for undo-tree compression

    (lib.mkIf (config.programs.gnupg.agent.enable)
      pinentry_emacs)   # in-emacs gnupg prompts

    ## Module dependencies
    # :checkers spell
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    # :checkers grammar
    languagetool
    # :tools lookup
    sqlite
    # :lang cc
    ccls
    # :lang javascript
    nodePackages.javascript-typescript-langserver
  ];

  fonts.fonts = [
    pkgs.emacs-all-the-icons-fonts
    pkgs.overpass
  ];

  my.env.PATH = [ "$HOME/.emacs.d/bin" ];
  my.zsh.rc = lib.readFile <config/emacs/aliases.zsh>;
}
