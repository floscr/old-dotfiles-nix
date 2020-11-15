{ config, options, lib, pkgs, ... }:
with lib;
{
  options.modules.dev.elixir = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.dev.elixir.enable {
    my.packages = with pkgs; [
      elixir
      postgresql
      inotify-tools
    ];
  };
}
