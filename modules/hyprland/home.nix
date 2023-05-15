{ lib, config, pkgs, system, host, user, hyprland, ... }:

let
  ####################
  # Hyprland startup #
  ####################
  nix-exec-dot-conf = ''
    exec-once = ${pkgs.waybar}/bin/waybar
    exec-once = ${pkgs.blueman}/bin/blueman-applet
    exec-once = ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator
    exec-once = ${pkgs.swaybg}/bin/swaybg -m center -i $HOME/.config/wallpaper
  '';

  ########################
  # Hyprland keybindings #
  ########################
  nix-bind-dot-conf = ''
    bind = , XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 10
    bind = , XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 10
    bind = , XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t
    bind = , XF86AudioMicMute, exec, ${pkgs.pamixer}/bin/pamixer --default-source -t
    bind = , XF86MonBrightnessDown, exec, ${pkgs.light}/bin/light -U 10
    bind = , XF86MonBrightnessUp, exec, ${pkgs.light}/bin/light -A 10

    bind = $mainMod, Return, exec, ${pkgs.alacritty}/bin/alacritty
    bind = $mainMod, Q, killactive
    bind = $mainMod, Escape, exit
    bind = $mainMod ALT, L, exec, ${pkgs.swaylock}/bin/swaylock
    bind = $mainMod, E, exec, ${pkgs.pcmanfm}/bin/pcmanfm
    bind = $mainMod, S, togglefloating
    bind = CTRL, Space, exec, ${pkgs.wofi}/bin/wofi --show drun
    bind = $mainMod, P, pseudo
    bind = $mainMod, F, fullscreen
    bind = $mainMod, R, forcerendererreload
    bind = $mainMod SHIFT, R, exec, ${pkgs.hyprland}/bin/hyprctl reload
    bind = $mainMod, T, exec, ${pkgs.emacs}/bin/emacsclient -c
  '';
in
{
  xdg.configFile."hypr" = {
    source = ./hypr;
    recursive = true;
  };
  xdg.configFile."hypr/nix-exec.conf".text = nix-exec-dot-conf;
  xdg.configFile."hypr/nix-bind.conf".text = nix-bind-dot-conf;
  xdg.configFile."wallpaper".source = ./wallpaper.png;
}
