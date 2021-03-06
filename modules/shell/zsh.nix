{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.shell.zsh = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.shell.zsh.enable {
    users.defaultUserShell = pkgs.zsh;

    my = {
      packages = with pkgs; [
        zsh
        bat
        bc
        nix-zsh-completions
        fzf
        fasd
        exa
        fd
        tmux
        htop
        (ripgrep.override { withPCRE2 = true; })
        neofetch
        # Badnwith monitor tui
        unstable.bandwhich
        # Cpu temperature tui
        s-tui
        udiskie
        tree
        zip
      ];

      env.ZDOTDIR   = "$XDG_CONFIG_HOME/zsh";
      env.ZSH_CACHE = "$XDG_CACHE_HOME/zsh";

      # Write it recursively so other modules can write files to it
      home.xdg.configFile."zsh" = {
        source = <config/zsh>;
        recursive = true;
      };
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      # I init completion myself, because enableGlobalCompInit initializes it too
      # soon, which means commands initialized later in my config won't get
      # completion, and running compinit twice is slow.
      enableGlobalCompInit = false;
      promptInit = "";
    };

    # system.userActivationScripts.cleanupZgen = "rm -fv $XDG_CACHE_HOME/zsh/*";
  };
}
