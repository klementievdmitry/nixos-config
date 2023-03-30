{ config, pkgs, user, ... }:

{
  imports =
    [ ( import ./hardware-configuration.nix ) ] ++
    [ ( import ../../modules/programs/games.nix ) ] ++
    [ ( import ../../modules/sway/default.nix ) ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };

      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };

      timeout = 2;
    };
  };
}
