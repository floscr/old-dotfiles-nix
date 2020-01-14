{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rustc
    cargo
    cargo-generate

    # stdenv deps
    gcc
    gnumake
    openssl
    pkgconfig
    binutils
  ];
}
