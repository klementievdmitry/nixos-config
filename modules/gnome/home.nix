{ config, lib, pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Settings.desktop"
        "firefox.desktop"
        "emacsclient.desktop"
        "com.obsproject.Studio.desktop"
        "discord.desktop"
        "steam.desktop"
        "com.parsecgaming.parsec.desktop"
        "blueman-manager.desktop"
        "pavucontrol.desktop"
        "org.gnome.Console.desktop"
      ];
    };
  };

  home.packages = with pkgs; [
  ];
}
