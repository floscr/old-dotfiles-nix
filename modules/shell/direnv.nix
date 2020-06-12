{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.shell.direnv = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.shell.direnv.enable {
    my = {
      packages = with pkgs; [
        direnv
      ];
      home.xdg.configFile = {
        # "zsh/rc.d/aliases.direnv.zsh".source = <config/direnv/aliases.zsh>;
        "direnv/direnvrc".source = <config/direnv/direnvrc>;
      };
    };
    programs = {
      bash.interactiveShellInit = ''
        eval "$(${pkgs.direnv}/bin/direnv hook bash)"
      '';
      zsh.interactiveShellInit = ''
        eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
      '';
      fish.interactiveShellInit = ''
        eval (${pkgs.direnv}/bin/direnv hook fish)
      '';
    };
  };
}
