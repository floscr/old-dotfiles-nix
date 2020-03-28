{ config, lib, pkgs, ... }:

{


  environment = {
    systemPackages = with pkgs; [
      dunst libnotify
    ];
  };

  my.home.xdg.configFile = {
    "dunst/dunstrc".text = ''
      [global]
        browser = ${pkgs.chromium}/bin/chromium
        dmenu = ${pkgs.rofi}/bin/rofi -dmenu -p dunst:
        follow = none
        history_length = 20
        idle_threshold = 120
        monitor = 0
        show_age_threshold = 60
        show_indicators = true
        shrink = false
        sort = true
        startup_notification = false
        sticky_history = true

        ## UI: Notification
        # geometry [{width}]x{height}][+/-{x}+/-{y}]
        geometry = 365x15-21+21
        alignment = left
        frame_width = 2
        frame_color = #1a1c25
        horizontal_padding = 20
        padding = 20
        icon_position = right
        separator_color = #1a1c25
        separator_height = 2
        transparency = 1
        max_icon_size = 64

        ## UI: Text
        # Don't bouce wrapped text
        markup = full
        # https://github.com/dwarmstrong/dotfiles/blob/master/.config/dunst/dunstrc#L40
        bounce_freq = 0
        format = "<b>%s</b>\n%b"
        # font = "Fira Sans 11"
        font = Iosevka 12
        line_height = 0
        ignore_newline = false
        indicate_hidden = true
        word_wrap = true

      [shortcuts]
        close = shift+space
        close_all = ctrl+shift+space
        history = ctrl+period
        context = ctrl+comma

      [urgency_low]
        background = "#1E2029"
        foreground = "#bbc2cf"
        timeout = 8
      [urgency_normal]
        background = "#2a2d39"
        foreground = "#bbc2cf"
        timeout = 14
      [urgency_critical]
        background = "#cc6666"
        foreground = "#1E2029"
        timeout = 0
    '';
  };

  systemd.user.services.dunst = {
    enable = true;
    description = "Notification daemon";
    wantedBy = [ "default.target" ];
    path = [ pkgs.dunst ];
    serviceConfig = {
      Restart = "always";
      RestartSec = 2;
      ExecStart = "${pkgs.dunst}/bin/dunst";
    };
  };
}
