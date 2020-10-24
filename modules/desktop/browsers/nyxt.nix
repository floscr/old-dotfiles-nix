{ config, options, lib, pkgs, ... }:
with lib; {
  options.modules.desktop.browsers.nyxt = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.browsers.nyxt.enable {
    my.packages = with pkgs;
      [
        my.nyxt
        (makeDesktopItem {
          name = "nyxt";
          desktopName = "Nyxt";
          genericName = "Open a Nyxt window";
          icon = "nyxt";
          exec = "nyxt";
          categories = "Network";
        })
      ];
    my.env.GDK_SCALE = "2";
    my.env.GDK_DPI_SCALE = "0.5";

    # my.home.xdg.configFile."nyxt" = {
    #   source = <config/nyxt>;
    #   recursive = true;
    # };
  };
}
