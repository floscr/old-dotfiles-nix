{ config, options, lib, pkgs, ... }:
with lib;

let greenclip = pkgs.haskellPackages.greenclip;
    utils = import <modules/utils.nix>;
in {
  options.modules.services.greenclip = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.services.greenclip.enable {
    my = {
      packages = [
        greenclip
        pkgs.xorg.libXdmcp
        (let rofi = "${pkgs.rofi}/bin/rofi";
         in pkgs.writeShellScriptBin "rofi-greenclip" ''
          #!${pkgs.stdenv.shell}
          ${rofi} -modi "clipboard:greenclip print" -show clipboard -run-command '{cmd}'
        '')
      ];

      bindings = [
        {
          binding = "super + shift + v";
          command = "rofi-greenclip";
          description = "Greenclip";
          categories = "Clipboard Manager";
        }
      ];
    };

    systemd.user.services.greenclip = {
      enable= true;
      description = "greenclip daemon";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${greenclip}/bin/greenclip daemon";
      };
    };
  };
}
