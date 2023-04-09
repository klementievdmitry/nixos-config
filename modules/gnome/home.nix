{ config, lib, pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "brave.desktop"
        "emacsclient.desktop"
        "com.obsproject.Studio.desktop"
        "steam.desktop"
        "com.parsecgaming.parsec.desktop"
        "org.gnome.Console.desktop"
        "element-desktop.desktop"
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

    "org/gnome/desktop/peripherals/keyboard" = {
      repeat-interval = 50;
      delay = 300;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
    };
  };

  home.packages = with pkgs; [
  ];
}
