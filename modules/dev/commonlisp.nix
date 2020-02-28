{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cl-launch
    sbcl
    lispPackages.quicklisp
  ];
}
