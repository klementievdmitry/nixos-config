{ lib, config, pkgs, helix, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      helix = helix.packages.helix;
    })
  ];

  environment.systemPackages = with pkgs; [
    helix
  ];
};
