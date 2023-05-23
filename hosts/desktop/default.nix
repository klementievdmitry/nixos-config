{ config, pkgs, user, ... }:

{
  imports =
    [ (import ./hardware-configuration.nix) ] ++ # Hardware conf
    [ (import ../base/default.nix) ] ++ # Base system configuration
    [ (import ../../modules/programs/games.nix) ] ++ # Games
    [ (import ../../modules/gnome/default.nix) ]; # Gnome
  
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [
    ];
    initrd.kernelModules = [
      "amdgpu"
      "k10temp"
    ];
    kernelParams = [];
  };

  # GPU Drivers
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
    };
  };
}
