{ config, lib, pkgs, ... }:

{
  my = {
    home.xdg.configFile."rofi" = {
      source = <config/rofi>;
      recursive = true;
    };

    packages = with pkgs; [
      (writeScriptBin "rofi" ''
        #!${stdenv.shell}
        exec ${rofi}/bin/rofi -terminal xst -m -1 "$@"
        '')
    ];

  };
}
