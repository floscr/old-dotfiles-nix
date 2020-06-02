{ config, lib, pkgs, ... }:
{
  services.redshift = {
    enable = true;
    temperature = {
      day = 5500;
      night = 3000;
    };
  };

  location = {
    longitude = 12.5;
    latitude = 55.88;
  };

  my.bindings = [
    {
      description = "Toggle Redshift";
      categories = "Script";
      command = "toggle_redshift";
    }
  ];
}
