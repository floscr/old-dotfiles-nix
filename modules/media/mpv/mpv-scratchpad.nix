{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.mpv-scratchpad = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.mpv-scratchpad.enable {
    my = {
      packages =
        with pkgs;
        let
          mpv-socket = "/home/${config.my.username}/.cache/mpv-scratchpad-socket";
          mpv-gallery-thumb-dir = "/home/${config.my.username}/.cache/mpv_gallery_cache";
          fullscreen-lock = "/home/${config.my.username}/.cache/mpv-scratchpad-fullscreen.lock";
        in [
          (pkgs.writeScriptBin "mpv-scratchpad" ''
            source /etc/dotfiles/bash-helpers/display.sh

            SOCKET=${mpv-socket}
            FULLSCREEN=${fullscreen-lock}
            rm -f $FULLSCREEN
            WIDTH=384
            HEIGHT=216
            PADDING=30
            POLYBAR_HEIGHT=35

            mkdir -p ${mpv-gallery-thumb-dir}

            echo ${mpv-socket}

            ${pkgs.mpv}/bin/mpv --input-ipc-server=$SOCKET --x11-name=mpvscratchpad --title=mpvscratchpad \
            --geometry=$WIDTHx$HEIGHT-32+62 --no-terminal --force-window --keep-open=yes --idle=yes&
            # ${pkgs.xdotool}/bin/xdotool getactivewindow windowmove $(($(screen_width) - $WIDTH - $PADDING)) 0
          '')
          (pkgs.writeShellScriptBin "mpv-scratchpad-toggle" ''
            VISIBLE_IDS=$(xdotool search --onlyvisible --classname 'mpvscratchpad')
            ALL_IDS=$(xdotool search --classname 'mpvscratchpad')
            ID=$(xdotool search --classname 'mpvscratchpad' | head -n1)
            FULLSCREEN=${fullscreen-lock}

            # if hidden, don't do anything
            [ -z $ALL_IDS ] && exit 0

            # sticky desktop
            bspc node $ID --flag sticky=on

            # toggle hide
            bspc node $ID --flag hidden

            ## else toggle fullscreen
            if [ -e "$FULLSCREEN" ]; then
              # is marked fullscreen, so should be fullscreen
              bspc node $ID --state fullscreen
              bspc node $ID --flag sticky=off
              bspc node --focus $ID
            else
              # is not marked fullscreen, so should be not marked fullscreen
              bspc node $ID --state floating
              bspc node $ID --flag sticky=on
              [ -z $VISIBLE_IDS ] && bspc node --focus $ID
              [ -z $VISIBLE_IDS ] && bspc node --focus last
            fi
            exit 0
          '')
          (pkgs.writeShellScriptBin "mpv-scratchpad-fullscreen-toggle" ''
            VISIBLE_IDS=$(xdotool search --onlyvisible --classname 'mpvscratchpad')
            ALL_IDS=$(xdotool search --classname 'mpvscratchpad')
            ID=$(xdotool search --classname 'mpvscratchpad' | head -n1)
            FULLSCREEN=${fullscreen-lock}

            # if hidden, don't do anything
            [ -z $ALL_IDS ] && exit 0

            # move mpv to front
            bspc node $ID --to-desktop newest

            bspc node $ID --flag hidden=off

            if [ -e "$FULLSCREEN" ]; then
              # is marked fullscreen, so should unmark (after unfullscreen)
              bspc node $ID --state floating
              bspc node $ID --flag sticky=on
              bspc node --focus $ID
              bspc node --focus last
              rm -f $FULLSCREEN
            else
              # is not marked fullscreen, so should become fullscreen
              # bspc node $ID --to-desktop newest
              bspc node $ID --state fullscreen
              bspc node $ID --flag sticky=off
              bspc node --focus $ID
              touch $FULLSCREEN
            fi
            exit 0
          '')
          (pkgs.writeShellScriptBin "mpv-scratchpad-hide" ''
            ID=$(xdotool search --classname 'mpvscratchpad' | head -n1)

            mpv-scratchpad-ctl pause
            bspc node $ID --flag sticky=on
            bspc node $ID --flag hidden=on
            exit 0
          '')
          (pkgs.writeShellScriptBin "mpv-scratchpad-open" ''
            mpv-scratchpad-ctl add "$@"
            for i in $(seq 1 1 50)
            do
            mpv-scratchpad-ctl next
            done
            mpv-scratchpad-ctl play
            exit 0
          '')
          (pkgs.writeShellScriptBin "mpv-scratchpad-ctl" ''
            socket=${mpv-socket}

            command() {
                # JSON preamble.
                local tosend='{ "command": ['
                # adding in the parameters.
                for arg in "$@"; do
                    tosend="$tosend \"$arg\","
                done
                # closing it up.
                tosend=''${tosend%?}' ] }'
                # send it along and ignore output.
                # to print output just remove the redirection to /dev/null
                # echo $tosend | socat - $socket &> /dev/null
                echo $tosend | socat - $socket
            }

            # exit mpv
            [ "$1" = "stop" ] && command 'stop'
            # toggle play-pause
            [ "$1" = "play-pause" ] && command 'cycle' 'pause'
            # start playing
            [ "$1" = "pause" ] && command 'set' 'pause' 'yes'
            # stop playing
            [ "$1" = "play" ] && command 'set' 'pause' 'no'
            # play next item in playlist
            [ "$1" = "next" ] && command 'playlist_next'
            # play previous item in playlist
            [ "$1" = "previous" ] && command 'playlist_prev'
            # seek forward
            [ "$1" = "forward" ] && command 'seek' "$2" 'relative'
            # seek backward
            [ "$1" = "backward" ] && command 'seek' "-$2" 'relative'
            # restart video
            [ "$1" = "restart" ] && (command 'seek' "0" 'absolute'; command 'set' 'pause' 'no')
            # end video
            [ "$1" = "end" ] && (command 'seek' "100" 'absolute-percent+exact'; command 'set' 'pause' 'no')
            # toggle video status
            [ "$1" = "video-novideo" ] && command 'cycle' 'video'
            # video status yes
            [ "$1" = "video" ] && command 'set' 'video' 'no' && command 'cycle' 'video'
            # video status no
            [ "$1" = "novideo" ] && command 'set' 'video' 'no'
            # add item(s) to playlist
            [ "$1" = "add" ] && shift &&
              for video in "$@"; do
                  command 'loadfile' "$video" 'append-play';
              done;
            # replace item(s) in playlist
            [ "$1" = "replace" ] && shift && command 'loadfile' "$1" 'replace';
          '')
          (pkgs.writeScriptBin "name" ''
            #!/usr/bin/env zsh

            _yt720p="136+140"
            _yt1080p="137+140"

            url=`bash -c 'echo $\{0:1:-1\}' $(emacsclient -e "(-last-item (+wm/last-chrome-window-url-title))")`

            echo "$url"

            playerctl pause

            mpv-scratchpad-open $url
          '')
        ];

      bindings = [
        {
          binding = "super + P";
          command = "mpv-scratchpad-toggle";
          description = "Toggle MPV Scratchpad";
        }
      ];
    };

    systemd.user.services.mpv-scratchpad = {
      enable = true;
      description = "MPV Scratchpad";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "mpv-scratchpad";
      };
    };
  };
}
