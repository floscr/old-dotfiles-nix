{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.ddcutil ];
  boot.kernelModules = [ "i2c_dev" ];
  users.groups = {
    i2c = {};
  };
  users.users.floscr = {
    extraGroups = [ "i2c" ];
  };
  services = {
      udev.extraRules = ''
KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
      '';
  };

  my.bindings = [
    {
      description = "Toggle Monitor Brightness";
      categories = "Script";
      command = "toggle_external_display_brightness";
    }
    {
      description = "Max Monitor Brightness";
      categories = "Script";
      command = "ddcutil setvcp 10 100";
    }
  ];
}
