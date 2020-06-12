{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.shell.ncmpcpp = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.shell.ncmpcpp.enable {
    my = {
      packages = with pkgs; [
        (ncmpcpp.override { visualizerSupport = true; })
      ];
      home.xdg.configFile = {
        "zsh/rc.d/aliases.ncmpcpp.zsh".source = <config/ncmpcpp/aliases.zsh>;
        "zsh/rc.d/env.ncmpcpp.zsh".source = <config/ncmpcpp/env.zsh>;
        "ncmpcpp/config".source = <config/ncmpcpp/config>;
        "ncmpcpp/bindings".source = <config/ncmpcpp/bindings>;
      };
    };
  };
}
