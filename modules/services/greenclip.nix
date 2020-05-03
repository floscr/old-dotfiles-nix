{ pkgs, ... }:

let greenclip = pkgs.haskellPackages.greenclip;
in {
  my.packages = [
    greenclip
    pkgs.xorg.libXdmcp
    (let rofi = "${pkgs.rofi}/bin/rofi";
     in pkgs.writeShellScriptBin "rofi-greenclip" ''
      #!${pkgs.stdenv.shell}
      ${rofi} -modi "clipboard:greenclip print" -show clipboard -run-command '{cmd}'
    '')
  ];

  systemd.user.services.greenclip = {
    enable= true;
    description = "greenclip daemon";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${greenclip}/bin/greenclip daemon";
    };
  };


  my.home.xdg.configFile = {
    "greenclip/cfg".text = ''
Config {
  maxHistoryLength           = 512,
  historyPath                = "~/.cache/greenclip.history",
  staticHistoryPath          = "~/.cache/greenclip.staticHistory",
  imageCachePath             = "/tmp/",
  usePrimarySelectionAsInput = True,
  blacklistedApps            = [ ],
  trimSpaceFromSelection     = False
}
'';
    "sxhkd/sxhkdrc".text = ''
super + shift + v
    rofi-greenclip
'';
  };
}
