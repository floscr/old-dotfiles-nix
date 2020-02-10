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

  services.xserver.videoDrivers = ["intel"];

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
    START_CHARGE_THRESH_BAT0=75
    STOP_CHARGE_THRESH_BAT0=92
    CPU_SCALING_GOVERNOR_ON_BAT=powersave
    ENERGY_PERF_POLICY_ON_BAT=powersave
    '';
  };

  # https://gist.github.com/Yatoom/1c80b8afe7fa47a938d3b667ce234559
  services.thinkfan.enable = true;
  services.thinkfan.sensors = ''
    hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp3_input
    hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp4_input
    hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp1_input
    hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp5_input
    hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp2_input
  '';
  services.thinkfan.levels = ''
    (0, 0, 68)
    (1, 50, 70)
    (2, 68, 74)
    (3, 72, 75)
    (4, 74, 78)
    (5, 76, 80)
    (7, 78, 32767)
 '';

  services.throttled = {
    enable = true;
    extraConfig = ''
      [GENERAL]
      # Enable or disable the script execution
      Enabled: True
      # SYSFS path for checking if the system is running on AC power
      Sysfs_Power_Path: /sys/class/power_supply/AC*/online

      ## Settings to apply while connected to AC power
      [AC]
      # Update the registers every this many seconds
      Update_Rate_s: 10
      # Max package power for time window #1
      PL1_Tdp_W: 42
      # Time window #1 duration
      PL1_Duration_s: 28
      # Max package power for time window #2
      PL2_Tdp_W: 44
      # Time window #2 duration
      PL2_Duration_S: 0.002
      # Max allowed temperature before throttling
      Trip_Temp_C: 66
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

      ## Settings to apply while connected to Battery power
      [BATTERY]
      # Update the registers every this many seconds
      Update_Rate_s: 10
      # Max package power for time window #1
      PL1_Tdp_W: 42
      # Time window #1 duration
      PL1_Duration_s: 28
      # Max package power for time window #2
      PL2_Tdp_W: 44
      # Time window #2 duration
      PL2_Duration_S: 0.002
      # Set HWP energy performance hints to 'performance' on high load (EXPERIMENTAL)
      HWP_Mode: True
      # Max allowed temperature before throttling
      Trip_Temp_C: 66
      # Set cTDP to normal=0, down=1 or up=2 (EXPERIMENTAL)
      cTDP: 2

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
}
