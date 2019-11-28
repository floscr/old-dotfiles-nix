{ config, lib, pkgs, ... }:

{
  imports = [
    # ../misc/throttled.nix
    ./monitor.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      fwupd
      undervolt
    ];
  };

  # Integrated graphics driver
  environment.variables = {
    MESA_LOADER_DRIVER_OVERRIDE = "iris";
  };
  hardware.opengl.package = (pkgs.mesa.override {
    galliumDrivers = [ "nouveau" "virgl" "swrast" "iris" ];
  }).drivers;

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver # only available starting nixos-19.03 or the current nixos-unstable
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
  boot.kernelModules = [
    "kvm-intel"
  ];

  services.upower.enable = true;

  services.tlp = {
    enable = true;
    extraConfig = ''
      CPU_SCALING_GOVERNOR_ON_AC=performance
      CPU_SCALING_GOVERNOR_ON_BAT=powersave
      CPU_SCALING_MIN_FREQ_ON_AC=1600000
      CPU_SCALING_MAX_FREQ_ON_AC=4800000
      CPU_SCALING_MIN_FREQ_ON_BAT=400000
      CPU_SCALING_MAX_FREQ_ON_BAT=3000000
      CPU_HWP_ON_AC=balance_performance
      CPU_HWP_ON_BAT=balance_power
      CPU_MIN_PERF_ON_AC=0
      CPU_MAX_PERF_ON_AC=100
      CPU_MIN_PERF_ON_BAT=0
      CPU_MAX_PERF_ON_BAT=80
      CPU_BOOST_ON_AC=1
      CPU_BOOST_ON_BAT=0
      SCHED_POWERSAVE_ON_AC=0
      SCHED_POWERSAVE_ON_BAT=1
      ENERGY_PERF_POLICY_ON_AC=performance
      ENERGY_PERF_POLICY_ON_BAT=powersave
      PCIE_ASPM_ON_AC=performance
      PCIE_ASPM_ON_BAT=powersave
      DEVICES_TO_DISABLE_ON_DOCK="wifi"
      DEVICES_TO_ENABLE_ON_UNDOCK="wifi"
      '';
  };

  # services.thinkfan.enable = true;
  # services.thinkfan.sensors = ''
  #   hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp3_input
  #   hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp4_input
  #   hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp1_input
  #   hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp5_input
  #   hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp2_input
  #   hwmon /sys/devices/virtual/thermal/thermal_zone2/hwmon1/temp1_input
  #   hwmon /sys/devices/virtual/thermal/thermal_zone3/hwmon2/temp1_input
  #   hwmon /sys/devices/virtual/thermal/thermal_zone6/hwmon4/temp1_input
  # '';

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
      Trip_Temp_C: 65
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
      cTDP: 2

      [UNDERVOLT.AC]
      # CPU core voltage offset (mV)
      CORE: -95
      # Integrated GPU voltage offset (mV)
      GPU: -85
      # CPU cache voltage offset (mV)
      CACHE: -105
      # System Agent voltage offset (mV)
      UNCORE: -85
      # Analog I/O voltage offset (mV)
      ANALOGIO: 0

      [UNDERVOLT.BATTERY]
      # CPU core voltage offset (mV)
      CORE: -95
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
