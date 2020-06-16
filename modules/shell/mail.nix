{ config, options, lib, pkgs, ... }:

with lib;
let
  name = "Florian Schrödl";
  maildir = "/home/floscr/.mail";
  email = "hello@florianschroedl.com";
  protonmail = "floscr@protonmail.com";
  notmuchrc = "/home/floscr/.config/notmuch/notmuchrc";
in {
  options.modules.shell.mail = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.shell.mail.enable {
    my = {
      packages = with pkgs; [
        unstable.mu
        isync
      ];
      home = {
        accounts.email = {
          maildirBasePath = maildir;
          accounts = {
            Work = {
              address = config.my.workEmail;
              userName = config.my.workEmail;
              flavor = "gmail.com";
              passwordCommand = "${pkgs.pass}/bin/pass Services/gmail.com/isync.florian@meisterlabs.com";
              primary = true;
              # gpg.encryptByDefault = true;
              mbsync = {
                enable = true;
                create = "both";
                expunge = "both";
                patterns = [ "*" "[Gmail]*" ]; # "[Gmail]/Sent Mail" ];
              };
              realName = name;
              msmtp.enable = true;
            };
          };
        };

        programs = {
          msmtp.enable = true;
          mbsync.enable = true;
        };

        services = {
          mbsync = {
            enable = true;
            frequency = "*:0/15";
            preExec = "${pkgs.isync}/bin/mbsync -Ha";
            postExec = "${pkgs.unstable.mu}/bin/mu index";
          };
        };
      };
    };
  };
}
