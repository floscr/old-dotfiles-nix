{ config, options, lib, pkgs, ... }:

with lib;
{
  options.modules.desktop.apps.rofi = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.desktop.apps.rofi.enable {
    my = {
      # link recursively so other modules can link files in its folder
      home.xdg.configFile."rofi" = {
        source = <config/rofi>;
        recursive = true;
      };

      bindings = [
        {
          binding = "super + shift + Tab";
          command = "/etc/dotfiles/bin/rofi/app_switch";
          description = "Switch application";
        }
      ];

      packages = with pkgs; [
        (writeScriptBin "rofi" ''
          #!${stdenv.shell}
          exec ${rofi}/bin/rofi -terminal xst -m -1 "$@"
          '')
      ];
    };
  };
}
