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
  fixKeyboard = pkgs.writeTextFile {
    name = "keyboard-setup";
    text = ''
      #!${pkgs.zsh}/bin/zsh

      # Save standard output and standard error
      exec 3>&1 4>&2
      # Redirect standard output to a log file
      exec 1>/tmp/stdout.log
      # Redirect standard error to a log file
      exec 2>/tmp/stderr.log

      echo "UHK connected!"
      sleep 1;
      /home/floscr/bin/setup-keyboard

      # Restore original stdout/stderr
      exec 1>&3 2>&4
      # Close the unused descriptors
      exec 3>&- 4>&-

      '';
    executable = true;
  };
in
{
  environment.etc."X11/keymap.xkb".source = keymap;

  environment.systemPackages = with pkgs; [
    xorg.xkbcomp
    xorg.xmodmap
  ];

  services = {
    xserver = {
      autoRepeatDelay = 190;
      autoRepeatInterval = 30;
      displayManager.sessionCommands = ''
        sh ~/bin/setup-keyboard&
        '';
    };
    # Setup keyboard rules when external keyboard gets plugged in
    udev = {
      extraRules = ''
          SUBSYSTEM=="usb", ACTION=="add", ENV{ID_VENDOR}=="Ultimate_Gadget_Laboratories", RUN+="${fixKeyboard}"
        '';
    };
  };

  powerManagement.resumeCommands = ''
    ~/bin/setup-keyboard&
  '';
}
