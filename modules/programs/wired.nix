{ config, lib, pkgs, wired, system, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      wired = wired.packages.${system}.wired;
    })
  ];

  environment.systemPackages = with pkgs; [
    wired
  ];
}
