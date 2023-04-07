{ pkgs, ... }:

{
  imports =
    [ ../../modules/sway/home.nix ]; # Sway WM

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
