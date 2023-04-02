{ config, pkgs, user, ... }:

{
  imports =
    [ ( import ./hardware-configuration.nix ) ] ++ # Hardware conf
    [ ( import ../../modules/programs/games.nix ) ] ++ # Games
    [ ( import ../../modules/sway/default.nix ) ]; # Sway WM

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    boot.initrd.kernelModules = [ "amdgpu" ];
    boot.kernelParams = [
      # For my laptop
      "nvme_core.default_ps_max_latency_us=0"

      # GPU Drivers
      "radeon.si_support=0"
      "amdgpu.si_support=1"
      "radeon.cik_support=0"
      "amdgpu.cik_support=1"
      "amdgpu.dc=1"
      "amdgpu.dpm=1"
    ];

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };

      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };

      timeout = 1;
    };
  };

  # GPU Drivers
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
    };
  };

  # HIP for programs like Blender
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
  ];

  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];

  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
  };

  #services.auto-cpufreq.enable = true;

  powerManagement = {
    #cpufreq.min = 1400000;
    #cpufreq.max = 2100000;
    cpuFreqGovernor = "performance";
  };

  # System76
  #hardware.system76 = {
  #  enableAll = true;
  #  power-daemon.enable = true;
  #  firmware-daemon.enable = true;
  #  kernel-modules.enable = true;
  #};

  #programs.corectrl = {
  #  enable = true;
  #  gpuOverclock.ppfeaturemask = "0xffffffff";
  #};

  security.polkit.enable = true;
}
