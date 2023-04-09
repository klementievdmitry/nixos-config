{ pkgs, ... }:

{
  imports =
    [ ../../modules/gnome/home.nix ];

  home = {
    packages = with pkgs; [
      #libreoffice # Office programs
    ];
  };

  services = {
    blueman-applet.enable = true;
    network-manager-applet.enable = true;
  };
}
