{ config, lib, pkgs, host, ... }:

let
  touchpad = with host;
    if hostName == "laptop" then ''
      touchpad {
        natural_scroll = true
        tap-to-click = true
        middle_button_emulation = true
      }
    '' else "";

  gestures = with host;
    if hostName == "laptop" then ''
      gestures {
        workspace_swipe = true
        workspace_swipe_fingers = 3
        workspace_swipe_distance = 100
      }
    '' else "";

  monitors = with host;
    ''
      monitor = , preffered, auto, 1
    '';

  workspaces = with host;
    ''
      # TODO: Workspace bindings for different monitors
    '';

  execute = with host;
    ''
      exec-once = ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator
      exec-once = ${pkgs.hyprpaper}/bin/hyprpaper
    '';
in
let
  hyprlandConf = with host;
  ''
    ${workspaces}
    ${monitors}

    $mainMod = SUPER

    general {
      border_size = 3
      gaps_in = 5
      gaps_out = 7
      col.active_border = 0x80ffffff
      col.inactive_border = 0x66333333
      layout = dwindle
    }

    decoration {
      rounding = 5
      multisample_edges = true
      active_opacity = 0.93
      inactive_opacity = 0.93
      fullscreen_opacity = 1
      blur = true
      drop_shadow = false
    }

    animations {
      enabled = true
      bezier = myBezier, 0.1, 0.7, 0.1, 1.05
      animation = fade, 1, 7, default
      animation = windows, 1, 7, myBezier
      animation = windowsOut, 1, 3, default, popin 60%
      animation = windowsMove, 1, 7, myBezier
    }

    input {
      kb_layout = us, de, ru
      kb_options = grp:caps_toggle
      repeat_rate = 50
      repeat_delay = 300
      numlock_by_default = true
      left_handed = false

      follow_mouse = true
      float_switch_override_focus = false

      ${touchpad}

      sensitivity = 0
    }

    ${gestures}

    dwindle {
      pseudotile = false
      force_split = 2
    }

    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow

    bind = $mainMod, Return, exec, ${pkgs.wezterm}/bin/wezterm
    bind = $mainMod, Q, killactive
    bind = $mainMod, Escape, exit
    bind = $mainMod, L, exec, ${pkgs.swaylock}/bin/swaylock
    bind = $mainMod, E, exec, ${pkgs.pcmanfm}/bin/pcmanfm
    bind = $mainMod, S, togglefloating
    bind = $mainMod, Space, exec, ${pkgs.wofi}/bin/wofi --show drun
    bind = $mainMod, P, pseudo
    bind = $mainMod, F, fullscreen
    bind = $mainMod, R, forcerendererreload
    bind = $mainMod SHIFT, R, exec, ${pkgs.hyprland}/bin/hyprctl reload
    bind = $mainMod, T, exec, ${pkgs.emacs}/bin/emacsclient -c

    bind = $mainMod, left, movefocus, l
    bind = $mainMod, right, movefocus, r
    bind = $mainMod, up, movefocus, u
    bind = $mainMod, down, movefocus, d

    bind = $mainMod SHIFT, left, movewindow, l
    bind = $mainMod SHIFT, right, movewindow, r
    bind = $mainMod SHIFT, up, movewindow, u
    bind = $mainMod SHIFT, down, movewindow, d

    bind = ALT, 1, workspace, 1
    bind = ALT, 2, workspace, 2
    bind = ALT, 3, workspace, 3
    bind = ALT, 4, workspace, 4
    bind = ALT, 5, workspace, 5
    bind = ALT, 6, workspace, 6
    bind = ALT, 7, workspace, 7
    bind = ALT, 8, workspace, 8
    bind = ALT, 9, workspace, 9
    bind = ALT, 0, workspace, 10
    bind = ALT CTRL, L, workspace, +1
    bind = ALT CTRL, H, workspace, -1

    bind = ALT SHIFT, 1, movetoworkspace, 1
    bind = ALT SHIFT, 2, movetoworkspace, 2
    bind = ALT SHIFT, 3, movetoworkspace, 3
    bind = ALT SHIFT, 4, movetoworkspace, 4
    bind = ALT SHIFT, 5, movetoworkspace, 5
    bind = ALT SHIFT, 6, movetoworkspace, 6
    bind = ALT SHIFT, 7, movetoworkspace, 7
    bind = ALT SHIFT, 8, movetoworkspace, 8
    bind = ALT SHIFT, 9, movetoworkspace, 9
    bind = ALT SHIFT, 0, movetoworkspace, 10
    bind = ALT SHIFT, right, movetoworkspace, +1
    bind = ALT SHIFT, left, movetoworkspace, -1

    bind = CTRL, right, resizeactive, 20 0
    bind = CTRL, left, resizeactive, -20 0
    bind = CTRL, up, resizeactive, 0 -20
    bind = CTRL, down, resizeactive, 0 20

    bind = , Print, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f - -o ~/Pictures/$(date +%Hh_%Mm_%Ss_%d_%B_%Y).png && notify-send "Saved to ~/Pictures/$(date +%Hh_%Mm_%Ss_%d_%B_%Y).png"

    bind = , XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 10
    bind = , XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 10
    bind = , XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t
    bind = , XF86AudioMicMute, exec, ${pkgs.pamixer}/bin/pamixer --default-source -t
    bind = , XF86MonBrightnessDown, exec, ${pkgs.light}/bin/light -U 10
    bind = , XF86MonBrightnessUp, exec, ${pkgs.light}/bin/light -A 10

    #windowrule = float,^(Rofi)$
    windowrule = float, title:^(Volume Control)$
    windowrule = float, title:^(Picture-in-Picture)$
    windowrule = pin, title:^(Picture-in-Picture)$
    windowrule = move 75% 75% , title:^(Picture-in-Picture)$
    windowrule = size 24% 24% , title:^(Picture-in-Picture)$

    exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec-once = ${pkgs.wired}/bin/wired
    exec-once = ${pkgs.waybar}/bin/waybar
    exec-once = ${pkgs.blueman}/bin/blueman-applet

    ${execute}
  '';
in
{
  xdg.configFile."hypr/hyprland.conf".text = hyprlandConf;
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ~/.config/wall.jpg
    wallpaper = , ~/.config/wall.jpg
  '';
}
