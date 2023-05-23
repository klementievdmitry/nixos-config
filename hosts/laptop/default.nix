{ config, pkgs, user, ... }:

{
  imports =
    [ (import ./hardware-configuration.nix) ] ++ # Hardware conf
    [ (import ../../modules/gnome/default.nix) ];
  
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [
    ];
    initrd.kernelModules = [
      "amdgpu"
      "k10temp"
    ];
    kernelParams = [
      "nvme_core.default_ps_max_latency_us=0"
    ];
  };

  # GPU Drivers
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
    };
  };
}
