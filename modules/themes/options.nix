# modules/themes/options.nix

{ options, config, lib, pkgs, ... }:
with lib;
{
  options.theme = {
    wallpaper = mkOption {
      type = with types; nullOr (either str path);
    };

    font = mkOption {
      type = with types; submodule({ name, ... }: {
        options.primary = mkOption { type = str; };
      });
      default = {
        primary = "Iosevka";
      };
    };

    colors = mkOption {
      type = with types; submodule({ name, ... }: {
        options.black1 = mkOption { type = str; };
        options.white = mkOption { type = str; };
        options.grey1 = mkOption { type = str; };
        options.grey2 = mkOption { type = str; };
        options.red = mkOption { type = str; };
        options.bred = mkOption { type = str; };
        options.grn = mkOption { type = str; };
        options.bgrn = mkOption { type = str; };
        options.yellow = mkOption { type = str; };
        options.byellow = mkOption { type = str; };
        options.blue = mkOption { type = str; };
        options.bblue = mkOption { type = str; };
        options.mag = mkOption { type = str; };
        options.bmag = mkOption { type = str; };
        options.cyn = mkOption { type = str; };
        options.bcyn = mkOption { type = str; };
        # Aliases
        options.terminalBackground = mkOption { type = str; };
        options.text = mkOption { type = str; };
      });
      default = {
        black1 = "#141517";
        white = "#ffffff";
        grey1 = "#c5c8c6";
        grey2 = "#969896";
        red = "#cc6666";
        bred = "#de935f";
        grn = "#b5bd68";
        bgrn = "#757d28";
        yellow = "##f0c674";
        byellow = "#f9a03f";
        blue = "#81a2be";
        bblue = "#2a8fed";
        mag = "#b294bb";
        bmag = "#bc77a8";
        cyn = "#8abeb7";
        bcyn = "#a3685a";
        # Aliases
        terminalBackground = config.theme.colors.black1;
        text = config.theme.colors.grey1;
      };
    };
  };

  config = {
    my.home.home.file.".background-image".source = config.theme.wallpaper;
    services.xserver.displayManager.lightdm.background =
      let blurredWallpaper =
            with pkgs; runCommand "blurWallpaper"
              { buildInputs = [ imagemagickBig ]; } ''
                mkdir "$out"
                convert -gaussian-blur 0x2 -modulate 70 -level 5% \
                  ${config.theme.wallpaper} $out/wallpaper.blurred.png
              '';
      in mkIf (config.theme.wallpaper != null)
        "${blurredWallpaper}/wallpaper.blurred.png";
  };
}
