{ config, lib, pkgs, ... }:
with lib;
{
  imports = [
    ./chromium.nix
    ./firefox.nix
  ];

  options.modules.desktop.browsers = {
    default = mkOption {
      type = with types; nullOr str;
      default = null;
    };
  };

  config = mkIf (config.modules.desktop.browsers.default != null) {
    my.env.BROWSER = config.modules.desktop.browsers.default;
    my.home.xdg.configFile = {
      "browser/home.html".text = ''
        <html>
          <head>
            <style type="text/css" media="screen">
              html {
                  background-color: ${config.theme.colors.background};
              }
            </style>
          </head>
        </html>
      '';
    };
  };

}
