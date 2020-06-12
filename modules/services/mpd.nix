{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.services.mpd = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.services.mpd.enable {
    my = {
      packages = with pkgs; [
        mpc_cli
      ];
      env.MPD_HOME = "$XDG_CONFIG_HOME/mpd";
    };

    services.mpd = {
      enable = true;
      musicDirectory = "/home/floscr/Media/Music";
      startWhenNeeded = true;
      extraConfig = ''
        input {
            plugin "curl"
        }
        audio_output {
            type        "pulse"
            name        "pulse audio"
        }
        audio_output {
            type        "fifo"
            name        "mpd_fifo"
            path        "/tmp/mpd.fifo"
            format      "44100:16:2"
        }
      '';
    };
  };
}
