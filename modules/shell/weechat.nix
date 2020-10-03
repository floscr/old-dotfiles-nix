{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.shell.weechat = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.shell.weechat.enable {
    my = {
      env.WEECHAT_HOME = "$XDG_CONFIG_HOME/weechat";
      packages = with pkgs; [
        weechat
      ];
    };
  };
}
