{ config, lib, pkgs, ... }:

{
  services.compton = {
    enable = true;
    backend = "glx";
    vSync = true;
    opacityRules = [
      "100:name *= 'i3lock'"
      "100:name *= 'Chromium'"
      "100:class_g ?= 'emacs'"
    ];
  };
}
