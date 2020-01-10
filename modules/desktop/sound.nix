#Enables bluetooth headset using bluez5 and pulseaudio
{ pkgs, ... }:

let
  unstable = import <nixpkgs-unstable> {
    config.allowUnfree = true;
  };
  # Spotify is terrible on hidpi screens (retina, 4k); this small wrapper
  # passes a command-line flag to force better scaling.
  spotify-4k = pkgs.symlinkJoin {
    name = "spotify";
    paths = [ unstable.spotify ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/spotify \
        --add-flags "--force-device-scale-factor=1.5"
    '';
  };

in
{
  #sudo rfkill unblock bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    extraConfig = ''
        ControllerMode = bredr
        [Headset]
        HFP=true
        MaxConnected=1
        FastConnectable=true
        [General]
        Disable=Headset
        AutoEnable=true
        MultiProfile=multiple
        AutoConnect=true
        Enable=Source,Sink,Media,Socket
        '';
  };
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
    extraModules = [
      unstable.pulseaudio-modules-bt
    ];
    # https://medium.com/@gamunu/enable-high-quality-audio-on-linux-6f16f3fe7e1f
    daemon.config = {
      default-sample-format = "float32le";
      default-sample-rate = 48000;
      alternate-sample-rate = 44100;
      default-sample-channels = 2;
      default-channel-map = "front-left,front-right";
      default-fragments = 2;
      default-fragment-size-msec = 125;
      resample-method = "soxr-vhq";
      enable-lfe-remixing = "no";
      high-priority = "yes";
      nice-level = -11;
      realtime-scheduling = "yes";
      realtime-priority = 9;
      rlimit-rtprio = 9;
      daemonize = "no";
    };
  };

  sound.extraConfig = ''
    # Use PulseAudio plugin hw
    pcm.!default {
      type plug
      slave.pcm hw
    }
  '';

  nixpkgs.config = {
    packageOverrides = pkgs: {
      bluez = pkgs.bluez5;
    };
  };

  environment.systemPackages = with pkgs; [
    playerctl
    pavucontrol
    blueman
    spotify-4k
  ];
}
