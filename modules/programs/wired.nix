{ config, lib, pkgs, wired, system, user, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      wired = wired.packages.${system}.wired;
    })
  ];

  environment.systemPackages = with pkgs; [
    wired
  ];

  home-manager.users.${user} = {
    xdg.configFile."wired/wired.ron".source = ./wired.ron;
  };
}
