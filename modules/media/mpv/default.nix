{ config, pkgs, ... }:

let
  mpv-thumbs-cache = "/tmp/mpv_thumbs_cache";
  mpv-gallery-thumb-dir = "/tmp/mpv_gallery_cache";
in {
  imports = [
    ./mpv-scratchpad.nix
  ];

  environment.systemPackages = with pkgs; [
    mpvc

    # Peerflix
    socat
    nodePackages.peerflix

    (mpv-with-scripts.override {
      scripts = [
        pkgs.mpvScripts.mpris # playerctl support
        (fetchurl {
          # autospeed
          url = "https://raw.githubusercontent.com/kevinlekiller/mpv_scripts/master/autospeed/autospeed.lua";
          sha256 = "18m0lzf0gs3g0mfgwfgih6mz98v5zcciykjl7jmg9rllwsx8syjl";
        })
        (fetchurl {
          # autoload
          url = "https://raw.githubusercontent.com/mpv-player/mpv/master/TOOLS/lua/autoload.lua";
          sha256 = "0ifml25sc1mxv0m4qy50xshsx75560zmwj4ivys14vnpk1j40m1r";
        })
        (fetchurl {
          # reload
          url = "https://raw.githubusercontent.com/4e6/mpv-reload/2b8a719fe166d6d42b5f1dd64761f97997b54a86/reload.lua";
          sha256 = "0dyx22rr1883m2lhnaig9jdp7lpjydha0ad7lj9pfwlgdr2zg4b9";
        })
        (fetchurl {
          # youtube-quality - ctrl + f
          url = "https://raw.githubusercontent.com/jgreco/mpv-youtube-quality/d03278f07bd8e202845f4a8a5b7761d98ad71878/youtube-quality.lua";
          sha256 = "0fi1b4r5znp2k2z590jrrbn6wirx7nggjcl1frkcwsv7gmhjl11l";
        })
        (fetchurl {
          # peerflix-hook
          url = "https://gist.githubusercontent.com/floscr/004f4b4d840a6ee0be40328744525c74/raw/903a183827d943abd4a914d0666a337f4e403f9c/peerflix-hook.lua";
          sha256 = "945c32353f2ee16b4838f9384e8428fff9705dcfb3838ac03b4dab45c58ceef0";
        })
      ];
    })
  ];

  my.home = {
      xdg = {
          mimeApps.defaultApplications = {
              "audio/x-mp3" = [ "mpv.desktop" ];
          };
          configFile =
            let
                mpv-gallery-view = (pkgs.fetchFromGitHub {
                owner = "occivink";
                repo = "mpv-gallery-view";
                rev = "4ecf6d72523b1385f4122d69b9045b447dfbb4f8";
                sha256 = "0mwkmy95f1jl6cli0arvp6xh02rdp41ylal5pg9cdrvfrnjvqn67";
                });
            in {
                # mpv-gallery-view
                "mpv/scripts/lib".source = "${mpv-gallery-view}/scripts/lib";
                "mpv/scripts/gallery-thumbgen.lua".source = "${mpv-gallery-view}/scripts/gallery-thumbgen.lua";
                "mpv/scripts/playlist-view.lua".source = "${mpv-gallery-view}/scripts/playlist-view.lua";

                # Copy time stamp of web videos
                "mpv/scripts/copy-timestamp.lua".source = ./scripts/input-copy-timestamped-url.lua;
                "mpv/scripts/lib-copy-paste.lua".source = ./scripts/lib-copy-paste.lua;
                "mpv/scripts/lib-web-video.lua".source = ./scripts/lib-web-video.lua;

                # Keep log of videos played
                "mpv/scripts/keep-history-log.lua".source = ./scripts/keep-history-log.lua;

                "mpv/scripts/mpv_thumbnail_client-1.lua".source =
                    (pkgs.fetchurl {
                    # mpv thumbnail client
                    url = "https://github.com/TheAMM/mpv_thumbnail_script/releases/download/0.4.2/mpv_thumbnail_script_client_osc.lua";
                    sha256 = "1g8g0l2dfydmbh1rbsxvih8zsyr7r9x630jhw95jwb1s1x8izrr7";
                    });

                "mpv/scripts/mpv_thumbnail_server.lua".source =
                    (pkgs.fetchurl {
                    # mpv thumbnail server
                    url = "https://github.com/TheAMM/mpv_thumbnail_script/releases/download/0.4.2/mpv_thumbnail_script_server.lua";
                    sha256 = "12flp0flzgsfvkpk6vx59n9lpqhb85azcljcqg21dy9g8dsihnzg";
                    });

                "mpv/script-opts/mpv_thumbnail_script.conf".text = ''
                    cache_directory=${mpv-thumbs-cache}
                    autogenerate=yes
                    autogenerate_max_duration=1800
                    prefer_mpv=yes
                    mpv_no_sub=no
                    disable_keybinds=no
                    thumbnail_width=150
                    thumbnail_height=150
                    thumbnail_count=100
                    min_delta=5
                    max_delta=90
                    thumbnail_network=yes
                    remote_thumbnail_count=40
                    remote_min_delta=15
                    remote_max_delta=120
                '';

                "mpv/script-opts/playlist_view.conf".text = ''
                    thumbs_dir=${mpv-gallery-thumb-dir}

                    generate_thumbnails_with_mpv=yes

                    gallery_position={ (ww - gw) / 2, (wh - gh) / 2 }
                    gallery_size={ 9 * ww / 10, 9 * wh / 10 }
                    min_spacing={ 15, 15 }
                    thumbnail_size=(ww * wh <= 1366 * 768) and {192, 108} or {288, 162}

                    max_thumbnails=64

                    take_thumbnail_at=20%

                    load_file_on_toggle_off=no
                    close_on_load_file=yes
                    pause_on_start=yes
                    resume_on_stop=only-if-did-pause
                    start_on_mpv_startup=no
                    start_on_file_end=no
                    follow_playlist_position=yes
                    remember_time_position=yes

                    show_text=yes
                    show_title=yes
                    strip_directory=yes
                    strip_extension=yes
                    text_size=28

                    background_color=333333
                    background_opacity=33
                    normal_border_color=BBBBBB
                    normal_border_size=1
                    selected_border_color=DDDDDD
                    selected_border_size=6
                    flagged_border_color=5B9769
                    flagged_border_size=4
                    selected_flagged_border_color=BAFFCA
                    placeholder_color=222222

                    command_on_open=
                    command_on_close=

                    mouse_support=yes
                    UP=UP
                    DOWN=DOWN
                    LEFT=LEFT
                    RIGHT=RIGHT
                    PAGE_UP=PGUP
                    PAGE_DOWN=PGDWN
                    FIRST=HOME
                    LAST=END
                    RANDOM=r
                    ACCEPT=ENTER
                    CANCEL=ESC
                    # this only removes entries from the playlist, not the underlying file
                    REMOVE=DEL
                    FLAG=SPACE
                '';

                ## Bindings
                "mpv/input.conf".text = ''
                    ### Mouse Bindings
                    WHEEL_UP      add volume 2
                    WHEEL_DOWN    add volume -2
                    WHEEL_LEFT    add volume -2
                    WHEEL_RIGHT   add volume 2

                    ### Keyboard Bindings

                    l seek  5
                    L seek  60
                    h seek -5
                    H seek -60

                    Ctrl+h playlist-prev
                    Ctrl+l playlist-next

                    BS revert-seek
                    Ctrl+0 seek 0 absolute-percent
                    Ctrl+1 seek 10 absolute-percent
                    Ctrl+2 seek 20 absolute-percent
                    Ctrl+3 seek 30 absolute-percent
                    Ctrl+4 seek 40 absolute-percent
                    Ctrl+5 seek 50 absolute-percent
                    Ctrl+6 seek 60 absolute-percent
                    Ctrl+7 seek 70 absolute-percent
                    Ctrl+8 seek 80 absolute-percent
                    Ctrl+9 seek 90 absolute-percent

                    k add volume 5
                    j add volume -5
                    K add volume 10
                    J add volume -10

                    > multiply speed 11:10  # Extra speed
                    < multiply speed 9:10   # v speed
                    0 set speed 1.0         # Controlled speed

                    a cycle audio
                    s cycle sub

                    ### Video Modifications
                    + add video-zoom 0.5
                    - add video-zoom -0.5; script-message reset-pan-if-visible
                    = no-osd set video-zoom 0; script-message reset-pan-if-visible

                    # Toggle Pixel Interpolation
                    a cycle-values scale nearest ewa_lanczossharp

                    # Toggle color management on or off
                    c cycle icc-profile-auto

                    # Screenshot of the window output
                    S no-osd screenshot video

                    # Toggle aspect ratio information on and off
                    A cycle-values video-aspect "-1" "no"

                    # playlist view
                    g script-message playlist-view-toggle

                    # Copy time-stamped
                    Ctrl+y script-binding copy-timestamped-url
                '';

                "mpv/mpv.conf".text = ''
                    # MPV config

                    # Every possible settings are explained here:
                    # https://github.com/mpv-player/mpv/tree/master/DOCS/man

                    ## VIDEO

                    # X11
                    x11-bypass-compositor=yes
                    demuxer-thread=yes

                    # The default profile you use for your stuff. Always use this one
                    profile=gpu-hq

                    # The called API. Vulkan is highly recommended.
                    # Use "opengl" if you have compatibility problems
                    gpu-api=vulkan

                    # The backend with the API. Leave it "auto"
                    # Or use "winvk" with "gpu-api=vulkan" or "win" / "angle" with "gpu-api=opengl"
                    gpu-context=x11vk

                    # Choose the compiler for translating glsl code for Vulkan. Leave it "auto"
                    # Or use "shaderc" with a nVidia/AMD/Intel GPU or "nvidia" with a nVidia GPU
                    spirv-compiler=auto

                    # Scaling method
                    # ewa_lanczossharp is the most processor heavy, but also the prettiest
                    scale=ewa_lanczossharp
                    cscale=ewa_lanczossoft
                    # scale-radius=3
                    fbo-format=rgba16f

                    # Reduce stuttering caused by mismatches in the video fps
                    video-sync=display-resample
                    interpolation
                    tscale=oversample

                    # Sync up video with audio
                    autosync=30
                    framedrop=vo # Skip some frames to maintain A/V sync on slow systems
                    ontop=yes # Keep the player window on top of all other windows.

                    # Reduce banding
                    deband-iterations=2
                    deband-range=12
                    temporal-dither=yes

                    # Load the embedded ICC  profile contained in media files such  as PNG  images.
                    icc-profile-auto=yes
                    icc-cache-dir=/home/${config.my.username}/.cache/mpv-icc

                    ## UI

                    osc=no # Disable on-screen controls
                    script-opts=osc-layout=box

                    # Show UI when seeking
                    osd-on-seek=bar

                    cursor-autohide-fs-only
                    cursor-autohide=1000

                    keep-open=yes
                    save-position-on-quit
                    stop-screensaver=yes

                    # Start centered window
                    geometry=50%:50%
                    autofit-larger=60%x60%
                    autofit-smaller=10%x10%

                    ## CLI OUTPUT

                    msg-module       # prepend module name to log messages
                    msg-color        # color log messages on terminal
                    use-filedir-conf # look for additional config files in the directory of the opened file                        # 'auto' does not imply interlacing-detection

                    ## SCREENSHOTS

                    screenshot-format=png
                    screenshot-png-compression=0
                    screenshot-png-filter=0
                    screenshot-tag-colorspace=yes
                    screenshot-high-bit-depth=yes
                    screenshot-directory=/home/${config.my.username}/Media/Pictures/Screenshots

                    ## SUBTITLES

                    demuxer-mkv-subtitle-preroll              # try to correctly show embedded subs when seeking
                    sub-auto=fuzzy                            # external subs don't have to match the file name exactly to autoload
                    sub-file-paths=ass:srt:sub:subs:subtitles # search for external subs in the listed subdirectories
                    embeddedfonts=yes                         # use embedded fonts for SSA/ASS subs
                    sub-fix-timing=no                         # do not try to fix gaps (which might make it worse in some cases)
                    sub-ass-force-style=Kerning=yes           # allows you to override style parameters of ASS scripts

                    sub-scale-by-window=yes
                    sub-font-size=45
                    sub-color="#ffffffff"
                    sub-border-color="#000000"
                    sub-border-size=3.0
                    sub-shadow-offset=0.5
                    sub-shadow-color="#000000"

                    # Change subtitle encoding. For Arabic subtitles use 'cp1256'.
                    # If the file seems to be valid UTF-8, prefer UTF-8.
                    sub-codepage=utf8

                    # Languages
                    slang=en,eng,enm,de,deu,ger # automatically select these subtitles (decreasing priority)
                    alang=en,eng,de,deu,ger     # automatically select these audio tracks (decreasing priority)

                    ## YOUTUBE-DL / STREAMING VIDEO

                    # Use this user agent for streaming
                    user-agent = "Mozilla/5.0"

                    # Use max bitrate for HLS streaming
                    hls-bitrate=max

                    ytdl=yes
                    ytdl-format=bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best

                    # protocol config
                    [protocol.http]
                    force-window=immediate
                    [protocol.https]
                    force-window=immediate
                    [protocol.ytdl]
                    force-window=immediate
                    profile=protocol.http

                    ## AUDIO

                    alsa-resample=no
                    audio-channels=2
                    af=format=channels=2
                    audio-pitch-correction=yes
                    audio-display=no

                    [audio]
                    force-window=no
                    no-video
                    ytdl-format=bestaudio/best

                    ## IMAGES

                    [extension.webm]
                    loop-file=inf
                    [extension.gif]
                    loop-file=inf
                    [extension.jpeg]
                    loop-file=inf
                    [extension.png]
                    loop-file=inf
                    [extension.jpg]
                    loop-file=inf
                    [extension.gifv]
                    loop-file=inf
                '';
                };
      };
  };
}
