{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    i3lock-color
    (pkgs.writeScriptBin "lockscreen" ''
      #! ${pkgs.zsh}/bin/zsh

      background=292e39
      insidecolor=2e3440ff
      insidevercolor=81a1c1ff
      insidewrongcolor=d08770ff
      ringcolor=d8dee9ff
      ringvercolor=d8dee9ff
      ringwrongcolor=d8dee9ff
      keyhlcolor=a3be8cff
      bshlcolor=bf616aff
      layoutcolor=eceff4ff
      seperatorcolor=2e344000
      timecolor=e5e9f0ff
      datecolor=88c0d0ff
      verifcolor=81a1c1ff
      wrongcolor=d08770ff

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
        --indpos="x+w/2:y+200+h/2" \
        --radius=52 \
        --ring-width=20 \
        --noinputtext="" \
        \
        --clock \
        \
        --timecolor=$timecolor \
        --timestr="•%H %M•" \
        --timepos="x+w/2:y+64+h/2" \
        --time-font="Fira Sans" \
        --timesize=64 \
        \
        --datecolor=$datecolor \
        --datestr="%A" \
        --datepos="x+w/2:y+h/2" \
        --date-font="Deadhead Script" \
        --datesize=256 \
        \
        --veriftext="Verifying" \
        --verifcolor=$verifcolor \
        --verif-font="Deadhead Script" \
        --verifpos="x+w/2:y+h/2" \
        --verifsize=256 \
        \
        --wrongtext="Try again" \
        --wrongcolor=$wrongcolor \
        --wrong-font="Deadhead Script" \
        --wrongpos="x+w/2:y+h/2" \
        --wrongsize=256 &&\

    '')
  ];
}
