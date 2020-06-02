{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gimp
    gimpPlugins.resynthesizer2
  ];

  home-manager.users.floscr.xdg.configFile = {
    "GIMP/2.10" = { source = <config/gimp>; recursive = true; };
  };

  my.bindings = [
    {
      description = "Gimp";
      categories = "Graphics";
      command = "gimp";
    }
  ];
}
