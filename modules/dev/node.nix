{ config, lib, pkgs, ... }:

{
  my = {
    packages = with pkgs; [
      nodejs-10_x
      nodePackages.npm
      nodePackages.eslint_d
    ];

    env.NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/config";
    env.NPM_CONFIG_CACHE      = "$XDG_CACHE_HOME/npm";
    env.NPM_CONFIG_TMP        = "$XDG_RUNTIME_DIR/npm";
    env.NPM_CONFIG_PREFIX     = "$XDG_CACHE_HOME/npm";
    env.NODE_REPL_HISTORY     = "$XDG_CACHE_HOME/node/repl_history";

    home.xdg.configFile."npm/config".text = ''
        cache=$XDG_CACHE_HOME/npm
        prefix=$XDG_DATA_HOME/npm
      '';
  };
}
