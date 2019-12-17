{ config, lib, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      ocamlPackages.reason
      ocamlPackages.merlin
    ];
  };
}
