{ config, pkgs, user, ... }:

{
  imports =
    [ (import ./hardware-configuration.nix) ] ++ # Hardware conf
    [ (import ../../modules/programs/games.nix) ] ++ # Games
    [ (import ../../modules/sway/default.nix) ]; # Sway WM

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.kernelModules = [ "amdgpu" "k10temp" ];
    kernelParams = [
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

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (self: super: {
        discord = super.discord.overrideAttrs (
          _: {
            src = builtins.fetchTarball {
              url = "https://discord.com/api/download?platform=linux&format=tar.gz";
              sha256 = "04r1yx6aqd4f4lq7wfcgs3jfpn40gz7gwajzai1aqz12ny78rs7z";
            };
          }
        );
      })
    ];
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

  security.polkit.enable = true;

  # Forces a reset for specified bluetooth usb dongle.
  systemd.services.fix-generic-usb-bluetooth-dongle = {
    description = "Fixes for generic USB bluetooth dongle.";
    wantedBy = [ "post-resume.target" ];
    after = [ "post-resume.target" ];
    script = builtins.readFile ./scripts/hack.usb.reset;
    scriptArgs = "0a12:0001"; # Vendor ID and Product ID here
    serviceConfig.Type = "oneshot";
  };
}
