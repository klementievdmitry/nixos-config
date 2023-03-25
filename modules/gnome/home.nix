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

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      clock-show-weekday = true;
    };

    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };
  };

  home.packages = with pkgs; [
  ];
}
