{ pkgs, ... }:

{
  imports =
    [ ../../modules/sway/home.nix ]; # Sway WM

  home = {
    packages = with pkgs; [
      libreoffice # Office programs
      linuxKernel.packages.linux_xanmod_latest.system76-power
    ];
  };

  services = {
    blueman-applet.enable = true;
    network-manager-applet.enable = true;
  };
}
