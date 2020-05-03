{ pkgs, ... }:

let greenclip = pkgs.haskellPackages.greenclip;
in {
  my.packages = [
    greenclip
    pkgs.xorg.libXdmcp
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


  home-manager.users.floscr.xdg.configFile = {
    "greenclip/cfg".source = <config/greenclip/gc.cfg>;
  };
}
