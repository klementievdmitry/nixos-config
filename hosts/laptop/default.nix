{ config, pkgs, user, ... }:

{
  imports =
    [ ( import ./hardware-configuration.nix ) ] ++
    [ ( import ../../modules/gnome/default.nix ) ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };

      #grub = {
      #  enable = true;
      #  version = 2;
      #  devices = [ "nodev" ];
      #  efiSupport = true;
      #  useOSProber = true;
      #  configurationLimit = 2;
      #};

      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };

      timeout = 2;
    };
  };
}
