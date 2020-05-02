# ReasonML

{ config, options, lib, pkgs, ... }:
with lib;
{
  options.modules.dev.reasonml = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.dev.node.enable {
    my = {
      packages = with pkgs; [
        ocamlPackages.reason
        ocamlPackages.merlin
      ];
    };
  };
}
