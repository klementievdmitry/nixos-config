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
      exec-once = ${pkgs.swaybg}/bin/swaybg
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
      kb_layout = us, ru
      kb_options = grp:alt_shift_toggle
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
    bind = $mainMod, H, togglefloating
    bind = $mainMod, Space, exec, ${pkgs.wofi}/bin/wofi --show drun
    bind = $mainMod, P, pseudo
    bind = $mainMod, F, fullscreen
    bind = $mainMod, R, forcerendererreload
    bind = $mainMod SHIFT, R, exec, ${pkgs.hyprland}/bin/hyprctl reload
    bind = $mainMod, T, exec, ${pkgs.emacs}/bin/emacsclient -c

    bind = $mainMod, H, movefocus, l
    bind = $mainMod, L, movefocus, r
    bind = $mainMod, K, movefocus, u
    bind = $mainMod, J, movefocus, d

    bind = SUPERSHIFT, H, movewindow, l
    bind = SUPERSHIFT, L, movewindow, r
    bind = SUPERSHIFT, K, movewindow, u
    bind = SUPERSHIFT, J, movewindow, d

    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10
    bind = $mainMod, L, workspace, +1
    bind = $mainMod, H, workspace, -1

    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10
    bind = $mainMod SHIFT, right, movetoworkspace, +1
    bind = $mainMod SHIFT, left, movetoworkspace, -1

    bind = CTRL, L, resizeactive, 20 0
    bind = CTRL, H, resizeactive, -20 0
    bind = CTRL, K, resizeactive, 0 -20
    bind = CTRL, J, resizeactive, 0 20

    bind = , Print, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f - -o ~/Pictures/$(date +%Hh_%Mm_%Ss_%d_%B_%Y).png && notify-send "Saved to ~/Pictures/$(date +%Hh_%Mm_%Ss_%d_%B_%Y).png"

    bind = , XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 10
    bind = , XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 10
    bind = , XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t
    bind = , XF86AudioMicMute, exec, ${pkgs.pamixer}/bin/pamixer --default-source -t
    bind = , XF86MonBrightnessDown, exec, ${pkgs.light}/bin/light -U 10
    bind = , XF86MonBrightnessUp, exec, ${pkgs.light}/bin/light -A 10

    #windowrule=float,^(Rofi)$
    windowrule=float,title:^(Volume Control)$
    windowrule=float,title:^(Picture-in-Picture)$
    windowrule=pin,title:^(Picture-in-Picture)$
    windowrule=move 75% 75% ,title:^(Picture-in-Picture)$
    windowrule=size 24% 24% ,title:^(Picture-in-Picture)$

    exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec-once=${pkgs.waybar}/bin/waybar
    exec-once=${pkgs.blueman}/bin/blueman-applet

    ${execute}
  '';
in
{
  xdg.configFile."hypr/hyprland.conf".text = hyprlandConf;

  programs.swaylock.settings = {
    #image = "$HOME/.config/wall";
    color = "000000f0";
    font-size = "24";
    indicator-idle-visible = false;
    indicator-radius = 100;
    indicator-thickness = 20;
    inside-color = "00000000";
    inside-clear-color = "00000000";
    inside-ver-color = "00000000";
    inside-wrong-color = "00000000";
    key-hl-color = "79b360";
    line-color = "000000f0";
    line-clear-color = "000000f0";
    line-ver-color = "000000f0";
    line-wrong-color = "000000f0";
    ring-color = "ffffff50";
    ring-clear-color = "bbbbbb50";
    ring-ver-color = "bbbbbb50";
    ring-wrong-color = "b3606050";
    text-color = "ffffff";
    text-ver-color = "ffffff";
    text-wrong-color = "ffffff";
    show-failed-attempts = true;
  };

  services.swayidle = with host; if hostName == "laptop" then {
    enable = true;
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f"; }
      { event = "lock"; command = "lock"; }
    ];
    timeouts = [
      { timeout= 300; command = "${pkgs.swaylock}/bin/swaylock -f";}
    ];
    systemdTarget = "xdg-desktop-portal-hyprland.service";
  } else {
    enable = false;
  };
}
