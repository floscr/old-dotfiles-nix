# modules/themes/options.nix

{ options, config, lib, pkgs, ... }:
with lib;
{
  options.theme = {
    wallpaper = mkOption {
      type = with types; nullOr (either str path);
    };

    font = mkOptStr "Iosevka";

    colors = mkOption {
      type = with types; nullOr submodule({ name, ... }: {
        options.black1 = str;
        options.black2 = str;
        options.white = str;
        options.grey1 = str;
        options.grey1blue = str;
        options.grey2 = str;
        options.red = str;
        options.bred = str;
        options.grn = str;
        options.bgrn = str;
        options.yellow = str;
        options.byellow = str;
        options.blue = str;
        options.bblue = str;
        options.mag = str;
        options.bmag = str;
        options.cyn = str;
        options.bcyn = str;

        # Aliases
        options.terminalBackground = str;
        options.background = str;
        options.text = str;
        options.fail = str;
        options.success = str;
      });
      default = {};
    };
  };
}
