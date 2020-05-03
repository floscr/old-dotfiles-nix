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
}
