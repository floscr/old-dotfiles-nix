# Node

{ config, options, lib, pkgs, ... }:
with lib;
{
  options.modules.dev.node = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.dev.node.enable {
    my = {
      # Stop node packages from showing ads in my darn CLI...
      env.ADBLOCK = "1";

      packages = with pkgs; [
        nodejs-10_x
      ];

      env.NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/config";
      env.NPM_CONFIG_CACHE      = "$XDG_CACHE_HOME/npm";
      env.NPM_CONFIG_TMP        = "$XDG_RUNTIME_DIR/npm";
      env.NPM_CONFIG_PREFIX     = "$XDG_CACHE_HOME/npm";
      env.NODE_REPL_HISTORY     = "$XDG_CACHE_HOME/node/repl_history";

      home.xdg.configFile."npm/config".text = ''
        cache=$XDG_CACHE_HOME/npm
        prefix=$XDG_DATA_HOME/npm
        update-notifier=false # I'll update via nix, thank you.
      '';
    };
  };
}
