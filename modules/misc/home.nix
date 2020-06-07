{ config, lib, pkgs, ... }:

let
  livingRoomCenter = "8";
  kitchenCeiling = "2";
  kitchenBoard = "10";
  entry = "3";
  livingRoomStandMiddle = "4";
  livingRoomStandLast = "5";
  bedRoomCeil = "11";
  bedRoomLed = "13";
in {
  my.packages = with pkgs; [
    hue-cli
    (pkgs.writeScriptBin "hue_living_room_full" ''
      #!${pkgs.stdenv.shell}
      hue ${livingRoomCenter} on;
      hue ${livingRoomCenter} brightness 100% &
      hue ${livingRoomStandMiddle} on
      hue ${livingRoomStandMiddle} brightness 100% &
      hue ${livingRoomStandLast} on
      hue ${livingRoomStandLast} brightness 100% &
    '')
    (pkgs.writeScriptBin "hue_living_room_read" ''
      #!${pkgs.stdenv.shell}
      hue ${livingRoomCenter} off&
      hue ${livingRoomStandMiddle} on
      hue ${livingRoomStandMiddle} brightness 10% &
      hue ${livingRoomStandLast} on
      hue ${livingRoomStandLast} brightness 100%&
    '')
  ];

  my.bindings = [
    {
      description = "Living Room Full";
      categories = "Hue Home";
      command = ''hue_living_room_full'';
    }
    {
      description = "Living Room Read";
      categories = "Hue Home";
      command = ''hue_living_room_full'';
    }
  ];
}
