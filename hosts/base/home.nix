{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
    ];
  };

  services = {
    blueman-applet.enable = true;
    network-manager-applet.enable = true;
  };
}
