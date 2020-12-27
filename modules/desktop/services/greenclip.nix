{ config, options, lib, pkgs, ... }:
with lib;

let greenclip = pkgs.haskellPackages.greenclip;
in {
  options.modules.services.greenclip = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf config.modules.services.greenclip.enable {
    my = {
      packages = [
        greenclip
        pkgs.xorg.libXdmcp
        (let rofi = "${pkgs.rofi}/bin/rofi";
             xdotool = "${pkgs.xdotool}/bin/xdotool";
             xclip = "${pkgs.xclip}/bin/xclip";
         in pkgs.writeShellScriptBin "rofi-greenclip" ''
            #!${pkgs.stdenv.shell}
            ${rofi} -modi "clipboard:greenclip print" -show clipboard -run-command '{cmd}'
            if [[ "$1" == "type" ]]; then
                sleep 0.5
                ${xdotool} type "$(${xclip} -o -selection clipboard)"
            fi
        '')
      ];

      bindings = [
        {
          binding = "super + shift + v";
          command = "rofi-greenclip";
          description = "Greenclip";
          categories = "Clipboard Manager";
        }
        {
          binding = "super + alt + shift + v";
          command = "rofi-greenclip type";
          description = "Greenclip (Type selection)";
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
