{ config, pkgs, user, ... }:

{
  imports =
    [ ( import ./hardware-configuration.nix ) ] ++ # Hardware conf
    [ ( import ../../modules/programs/games.nix ) ] ++ # Games
    [ ( import ../../modules/sway/default.nix ) ]; # Sway WM

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod;

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

  #programs.corectrl = {
  #  enable = true;
  #  gpuOverclock.ppfeaturemask = "0xffffffff";
  #};

  security.polkit.enable = true;
}
