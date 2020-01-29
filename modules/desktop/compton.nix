{ config, lib, pkgs, ... }:

{
  services.compton = {
    enable = true;
    backend = "xr_glx_hybrid";
    vSync = true;
    inactiveOpacity = "0.90";
    refreshRate = 0;
    opacityRules = [
      "100:name *= 'i3lock'"
      "100:name *= 'Chromium'"
      "100:class_g ?= 'emacs'"
    ];
  };
}
