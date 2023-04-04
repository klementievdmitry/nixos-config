{ config, pkgs, nur, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    lutris
    heroic
    prismlauncher
    retroarchFull
    protonup-ng
    protontricks
    #wineWowPackages.staging
    #(wine.override { wineBuild = "wine64" })
    #wine
    #wineWowPackages.stable
    wineWowPackages.waylandFull
    winetricks
    mangohud
  ];

  programs = {
    steam = {
      enable = true;
    };
    gamemode.enable = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
  ]; 
}
