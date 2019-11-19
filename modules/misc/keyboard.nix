{ config, lib, pkgs, ... }:

let
  keymap = pkgs.writeText "keymap.xkb" ''
    xkb_keymap {
      xkb_keycodes  { include "evdev+aliases(qwerty)"	};
      xkb_types     { include "complete"	};
      xkb_compat    { include "complete"	};
        xkb_symbols   {
            include "pc+us+inet(evdev)+ctrl(nocaps)+terminate(ctrl_alt_bksp)"
            key <AC01> { [ a, A, adiaeresis, Adiaeresis ] };
            key <AC02> { [ s, S, ssharp, U03A3 ] };
            key <AD09> { [ o, O, odiaeresis, Odiaeresis ] };
            key <AD07> { [ u, U, udiaeresis, Udiaeresis ] };
            include "level3(ralt_switch)"
        };
      xkb_geometry  { include "pc(pc104)"	};
    };
  '';
in
{
  environment.etc."X11/keymap.xkb".source = keymap;

  environment.systemPackages = with pkgs; [
    xorg.xkbcomp
    xorg.xmodmap
  ];

  services.xserver = {
    autoRepeatDelay = 190;
    autoRepeatInterval = 30;
    displayManager.sessionCommands = ''
        sh ~/bin/setup-keyboard&
        '';
  };

  powerManagement.resumeCommands = ''
    ~/bin/setup-keyboard&
  '';
}
