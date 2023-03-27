{ config, lib, pkgs, hyprpaper, user, system, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      hyprpaper = hyprpaper.packages.${system}.hyprpaper;
    })
  ];

  environment.systemPackages = with pkgs; [
    hyprpaper
  ];

  home-manager.users.${user} = {
    xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload = ~/.config/wall.jpg
      wallpaper = , ~/.config/wall.jpg
    '';
  };
}
