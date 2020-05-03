rec {
  mkBinding = { binding, command, description ? "" }: {
      "sxhkd/sxhkdrc".text = ''
        ${binding}
          ${command}
      '';
      "rofi/cmds".text = ''
        ${command};;;${binding};;;${description}
      '';
    };
}
