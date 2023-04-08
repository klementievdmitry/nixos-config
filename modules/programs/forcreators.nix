{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gimp
    libsForQt5.kdenlive
    blender
    audacity
  ];
}
