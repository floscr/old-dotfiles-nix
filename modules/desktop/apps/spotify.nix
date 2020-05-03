{ config, options, lib, pkgs, ... }:
with lib;
let
  # Spotify is terrible on hidpi screens (retina, 4k); this small wrapper
  # passes a command-line flag to force better scaling.
  spotify-4k = pkgs.symlinkJoin {
    name = "spotify";
    paths = [ pkgs.unstable.spotify ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/spotify \
        --add-flags "--force-device-scale-factor=1.5"
    '';
  };
in {
  options.modules.desktop.apps.spotify = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.apps.spotify.enable {
    my.packages = with pkgs; [
      spotify-4k
    ];
  };
}
