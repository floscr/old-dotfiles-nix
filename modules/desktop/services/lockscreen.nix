{ config, pkgs, lib, ... }:

with lib;

{
  options.modules.desktop.services.lockscreen = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf config.modules.desktop.services.lockscreen.enable {
    environment.systemPackages = with pkgs; [
      i3lock-color
      (with config.theme.colors; pkgs.writeScriptBin "lockscreen" ''
        #! ${pkgs.zsh}/bin/zsh

        background=${background}
        insidecolor=${background}ff
        insidevercolor=${background}ff
        insidewrongcolor=${fail}ff
        ringcolor=${grey1blue}1A
        ringvercolor=${grey1blue}ff
        ringwrongcolor=${fail}ff
        keyhlcolor=${success}ff
        bshlcolor=${fail}ff
        layoutcolor=${grey1blue}ff
        seperatorcolor=${black2}00
        timecolor=${grey1blue}7f
        datecolor=${cyn}ff
        verifcolor=${blue}ff
        wrongcolor=${fail}ff

        ${pkgs.i3lock-color}/bin/i3lock-color \
          -n \
          --indicator \
          -c $background \
          -S=0 \
          --insidecolor=$insidecolor \
          --insidevercolor=$insidevercolor \
          --insidewrongcolor=$insidewrongcolor \
          \
          --ringcolor=$ringcolor \
          --ringvercolor=$ringvercolor \
          --ringwrongcolor=$ringwrongcolor \
          \
          --line-uses-inside \
          --keyhlcolor=$keyhlcolor \
          --bshlcolor=$bshlcolor \
          \
          --layoutcolor=$layoutcolor \
          --separatorcolor=$seperatorcolor \
          --indpos="x+w/2:y+h/1.4" \
          --radius=50 \
          --ring-width=14 \
          --noinputtext="Enter Password" \
          \
          --clock \
          \
          --timecolor=$timecolor \
          --timestr="%H:%M:%S" \
          --timepos="x+w/2:y+h/1.8" \
          --time-font="Fira Code" \
          --timesize=22 \
          \
          --datecolor=$datecolor \
          --datestr="%A" \
          --datepos="x+w/2:y+h/1.95" \
          --date-font="Fira Sans Bold" \
          --datesize=57 \
          \
          --veriftext="Verifying" \
          --verifcolor=$verifcolor \
          --verif-font="Fira Sans" \
          --verifpos="x+w/2:y+h/2" \
          --verifsize=30 \
          \
          --wrongtext="Try again" \
          --wrongcolor=$wrongcolor \
          --wrong-font="Fira Sans" \
          --wrongpos="x+w/2:y+h/2" \
          --wrongsize=30 &&\

      '')
    ];
  };
}
