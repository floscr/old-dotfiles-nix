{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    hue-cli
  ];

  my.bindings = [
    {
      description = "Living Room Center 100%";
      categories = "Hue Home";
      command = "hue 8 on; hue 8 brightness 100%";
    }
  ];
}
