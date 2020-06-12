{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.desktop.apps.xcolor = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.desktop.apps.xcolor.enable (
    let xcolor = pkgs.callPackages ../../packages/xcolor.nix { };
    in{
      my = {
        packages = with pkgs; [
          xcolor
        ];
        bindings = [
          {
            binding = "super + i";
            command = "xcolor | xclip -selection clipboard -in";
            description = "Get color";
          }
        ];
      };
    });
}
