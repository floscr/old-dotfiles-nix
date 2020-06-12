{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.shell.pass = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.shell.pass.enable {
    my = {
      packages = with pkgs; [
        (pass.withExtensions (exts: [
          exts.pass-otp
          exts.pass-genphrase
          exts.pass-import
        ]))
        (lib.mkIf (config.services.xserver.enable) rofi-pass)
      ];
      bindings = [
        {
          description = "Pass";
          categories = "Password Manager";
          command = "rofi-pass";
        }
      ];
      env.PASSWORD_STORE_DIR = "$HOME/.secrets/password-store";
    };
  };
}
