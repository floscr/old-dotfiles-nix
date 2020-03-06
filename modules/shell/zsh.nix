{ config, pkgs, libs, ... }:

let zgen = builtins.fetchGit "https://github.com/tarjoilija/zgen";
in
{
  environment = {
    variables = {
      ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
      ZSH_CACHE = "$XDG_CACHE_HOME/zsh";
    };

    systemPackages = with pkgs; [
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
      s-tui
      udiskie
      tree
      zip
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableGlobalCompInit = false; # I'll do it myself
    promptInit = "";
  };

  home-manager.users.floscr.xdg.configFile = {
    # link recursively so other modules can link files in this folder,
    # particularly in zsh/rc.d/*.zsh
    "zsh" = { source = <config/zsh>; recursive = true; };
  };
}
