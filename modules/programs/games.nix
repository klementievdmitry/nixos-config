{ config, pkgs, nur, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    lutris
    heroic
    prismlauncher
    retroarchFull
    protonup-ng
    protontricks
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
