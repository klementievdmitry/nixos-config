{ config, lib, pkgs, ... }:

with lib;
{
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "Dota 2.desktop"
        "firefox.desktop"
        "emacsclient.desktop"
        "com.obsproject.Studio.desktop"
        "steam.desktop"
        "com.parsecgaming.parsec.desktop"
        "org.gnome.Console.desktop"
        "element-desktop.desktop"
        "org.telegram.desktop.desktop"
        "discord.desktop"
        "org.gnome.Nautilus.desktop"
      ];
      disable-user-extensions = false;
      enabled-extensions = [
        "trayIconsReloaded@selfmade.pl"
        "bluetooth-quick-connect@bjarosze.gmail.com"
        "gsconnect@andyholmes.github.io"
        "Vitals@CoreCoding.com"
        "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
        "caffeine@patapon.info"
        "clipboard-indicator@tudmotu.com"
        "custom-hot-corners-extended@G-dH.github.com"
        "openweather-extension@jenslody.de"
        "tiling-assistant@leleat-on-github"
        "color-picker@tuberry"
      ];
    };
   
    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      switch-to-application-5 = [ ];
      switch-to-application-6 = [ ];
      switch-to-application-7 = [ ];
      switch-to-application-8 = [ ];
      switch-to-application-9 = [ ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      clock-show-weekday = true;
    };

    "org/gnome/desktop/privacy" = {
      report-technical-problems = "false";
    };
    
    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      action-right-click-titlebar = "toggle-maximize";
      action-middle-click-titlebar = "minimize";
      resize-with-right-button = true;
      mouse-button-modifier = "<Super>";
      button-layout = ":minimize,close";
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      repeat-interval = 50;
      delay = 300;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
    };

    "org/gnome/desktop/wm/keybindings" = {
      # maximize = ["<Super>Up"];                     # For floating
      # unmaximize = ["<Super>Down"];
      maximize = [ "@as []" ]; # For tilers
      unmaximize = [ "@as []" ];
      switch-to-workspace-left = [ "<Super>Left" ];
      switch-to-workspace-right = [ "<Super>Right" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      move-to-workspace-left = [ "<Shift><Super>Left" ];
      move-to-workspace-right = [ "<Shift><Super>Right" ];
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      move-to-workspace-5 = [ "<Shift><Super>5" ];
      move-to-monitor-left = [ "<Alt><Super>Left" ];
      move-to-monitor-right = [ "<Alt><Super>Right" ];
      close = [ "<Alt>F4" ];
      toggle-fullscreen = [ "<Super>f" ];
    };

    "org/gnome/mutter" = {
      workspaces-only-on-primary = false;
      center-new-windows = true;
      edge-tiling = false;                            # Disabled when tiling
    };

    "org/gnome/mutter/keybindings" = {
      #toggle-tiled-left = ["<Super>Left"];           # For floating
      #toggle-tiled-right = ["<Super>Right"];
      toggle-tiled-left = ["@as []"];                 # For tilers
      toggle-tiled-right = ["@as []"];
    };

    "org/gnome/shell/extensions/bluetooth-quick-connect" = {
      show-battery-icon-on = true;
      show-battery-value-on = true;
    };

    "org/gnome/shell/extensions/openweather" = {
      city = "52.7586837,52.28831670221607>Бузулук, Оренбургская область, Приволжский федеральный округ, Россия>0";
    };

    "org/gnome/desktop/input-sources" = with hm.gvariant; {
      per-window = true;
      sources = mkArray (type.tupleOf [type.string type.string]) [
        (mkTuple ["xkb" "us"])
        (mkTuple ["xkb" "ru"])
      ];
      xkb-options = mkArray type.string ["grp:win_space_toggle"];
    };
  };

  home.packages = with pkgs; [
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.bluetooth-quick-connect
    gnomeExtensions.gsconnect                         # kdeconnect enabled in default.nix
    gnomeExtensions.vitals
    gnomeExtensions.caffeine
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.auto-move-windows
    gnomeExtensions.custom-hot-corners-extended
    gnomeExtensions.openweather
    gnomeExtensions.tiling-assistant
    gnomeExtensions.color-picker
  ];
}

