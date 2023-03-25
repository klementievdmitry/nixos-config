{ pkgs, ... }:

{
  imports =
    [ ../../modules/hyprland/home.nix ];

  home = {
    packages = with pkgs; [
      libreoffice
    ];
  };

  services = {
    blueman-applet.enable = true;
    network-manager-applet.enable = true;
  };
}
