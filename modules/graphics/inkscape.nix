{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    inkscape
  ];
  my.bindings = [
    {
      description = "Inkscape";
      categories = "Graphics";
      command = "inkscape";
    }
  ];
}
