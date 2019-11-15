{ config, lib, pkgs, ... }:

{
  imports = [
    ../misc/throttled.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      fwupd
      undervolt
    ];
  };

  # Encryption
  boot.initrd.luks.devices = [{
    name = "root";
    device = "/dev/nvme0n1p2";
    preLVM = true;
  }];

  # Bios updates
  services.fwupd.enable = true;

  # Kernels
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" ];
  boot.kernelModules = [ "kvm-intel" ];

  # Power management
  services.tlp.enable = true;

  services.throttled = {
    enable = true;
    extraConfig = ''
      [GENERAL]
      # Enable or disable the script execution
      Enabled: True
      # SYSFS path for checking if the system is running on AC power
      Sysfs_Power_Path: /sys/class/power_supply/AC*/online

      ## Settings to apply while connected to Battery power
      [BATTERY]
      # Update the registers every this many seconds
      Update_Rate_s: 30
      # Max package power for time window #1
      PL1_Tdp_W: 29
      # Time window #1 duration
      PL1_Duration_s: 28
      # Max package power for time window #2
      PL2_Tdp_W: 44
      # Time window #2 duration
      PL2_Duration_S: 0.002
      # Max allowed temperature before throttling
      Trip_Temp_C: 60
      # Set cTDP to normal=0, down=1 or up=2 (EXPERIMENTAL)
      cTDP: 0

      ## Settings to apply while connected to AC power
      [AC]
      # Update the registers every this many seconds
      Update_Rate_s: 5
      # Max package power for time window #1
      PL1_Tdp_W: 44
      # Time window #1 duration
      PL1_Duration_s: 28
      # Max package power for time window #2
      PL2_Tdp_W: 44
      # Time window #2 duration
      PL2_Duration_S: 0.002
      # Max allowed temperature before throttling
      Trip_Temp_C: 65
      # Set HWP energy performance hints to 'performance' on high load (EXPERIMENTAL)
      HWP_Mode: True
      # Set cTDP to normal=0, down=1 or up=2 (EXPERIMENTAL)
      cTDP: 0

      [UNDERVOLT.AC]
      # CPU core voltage offset (mV)
      CORE: -105
      # Integrated GPU voltage offset (mV)
      GPU: -85
      # CPU cache voltage offset (mV)
      CACHE: -105
      # System Agent voltage offset (mV)
      UNCORE: -85
      # Analog I/O voltage offset (mV)
      ANALOGIO: 0

      # ## Settings to apply while connected to AC power
      # [AC]
      # # Update the registers every this many seconds
      # Update_Rate_s: 5
      # # Max package power for time window #1
      # PL1_Tdp_W: 44
      # # Time window #1 duration
      # PL1_Duration_s: 28
      # # Max package power for time window #2
      # PL2_Tdp_W: 44
      # # Time window #2 duration
      # PL2_Duration_S: 0.002
      # # Max allowed temperature before throttling
      # Trip_Temp_C: 75
      # # Set HWP energy performance hints to 'performance' on high load (EXPERIMENTAL)
      # HWP_Mode: True
      # # Set cTDP to normal=0, down=1 or up=2 (EXPERIMENTAL)
      # cTDP: 0

      # [UNDERVOLT.AC]
      # # CPU core voltage offset (mV)
      # CORE: 0
      # # Integrated GPU voltage offset (mV)
      # GPU: 0
      # # CPU cache voltage offset (mV)
      # CACHE: 0
      # # System Agent voltage offset (mV)
      # UNCORE: 0
      # # Analog I/O voltage offset (mV)
      # ANALOGIO: 0

      [UNDERVOLT.BATTERY]
      # CPU core voltage offset (mV)
      CORE: -105
      # Integrated GPU voltage offset (mV)
      GPU: -85
      # CPU cache voltage offset (mV)
      CACHE: -105
      # System Agent voltage offset (mV)
      UNCORE: -85
      # Analog I/O voltage offset (mV)
      ANALOGIO: 0

      # [ICCMAX.AC]
      # # CPU core max current (A)
      # CORE:
      # # Integrated GPU max current (A)
      # GPU:
      # # CPU cache max current (A)
      # CACHE:

      # [ICCMAX.BATTERY]
      # CPU core max current (A)
      # CORE:
      # # Integrated GPU max current (A)
      # GPU:
      # # CPU cache max current (A)
      # CACHE:
    '';
  };

  # Throttled takes care of temperature throttling
  # services.thermald = {
  #   enable = true;
  #   configFile = <config/thermald/thermal-conf.xml>;
  # };
  # home-manager.users.floscr.xdg.configFile = {
  #   "thermald/thermal-conf.xml".source = <config/thermald/thermal-conf.xml>;
  # };

  # Undervolting can be done by throttled, but here are settings that "worked" for me
  # services.undervolt.enable = true;
  # services.undervolt.coreOffset= "-110";
  # services.undervolt.temp= "95";
}
