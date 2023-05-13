{ config, pkgs, user, ... }:

{
  imports =
    [ (import ./hardware-configuration.nix) ] ++ # Hardware conf
    [ (import ../base/default.nix) ] ++ # Base system configuration
    [ (import ../../modules/gnome/default.nix) ]; # Gnome
  
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

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
    };
    overlays = [
      (self: super: {
        discord = super.discord.overrideAttrs (
          _: {
            src = builtins.fetchTarball {
              url = "https://discord.com/api/download?platform=linux&format=tar.gz";
              sha256 = "0mr1az32rcfdnqh61jq7jil6ki1dpg7bdld88y2jjfl2bk14vq4s";
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
}
