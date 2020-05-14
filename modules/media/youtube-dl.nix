{ config, options, lib, pkgs, ... }:
with lib;
{
  options.modules.media.youtube-dl = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.media.youtube-dl.enable {
    my.packages = with pkgs; [
      unstable.youtube-dl
    ];
    my.alias.youtube-dl-audio = "youtube-dl -x --audio-format vorbis --prefer-ffmpeg";
  };
}
