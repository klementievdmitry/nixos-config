{ config, lib, pkgs, user, ... }:

let
  bar_height = 25;
  bord_size = 2;
  colors = import ../theme/colors.nix;
in
{
  imports =
    [ (../programs/rofi.nix) ] ++
    [ (../programs/polybar.nix) ];

  xsession.windowManager.bspwm = {
    enable = true;

    settings = {
      border_width = bord_size;
      windows_gape = bord_size * 3;
      single_monocle = true;
      top_padding = bar_height;
      split_ratio = 0.52;
      borderless_monocle = true;
      gapless_monocle = true;
      focused_border_color = "${colors.primary}";
    };

    startupPrograms = [
      "${pkgs.polybar}/bin/polybar"
      "systemctl --user restart polybar"
    ];

    extraConfig = ''
            bspc monitor -d I II III IV V VI VII VIII IX X
      	  '';

    rules = {
      "discord" = { desktop = "^3"; follow = true; };
      "mpv" = { state = "fullscreen"; };
      "Pavucontrol" = { state = "floating"; };
    };
  };

  services.sxhkd = {
    enable = true;

    keybindings = {
      # terminal
      "super + Return" = "alacritty";
      "ctrl + space" = "${pkgs.rofi}/bin/rofi -show drun -theme $HOME/.config/rofi/style.rasi";

      # reload config
      "super + Escape" = "pkill -usr1 -x sxhkd";
      "super + shift + Escape" = "bspc wm -r";

      #Floating <->
      "super + f" = "bspc node focused -t ~floating";
      "super + s" = "bspc node -g ~sticky";
      "super + shift + f" = "bspc node focused -t ~fullscreen";

      #change focused
      "super + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";

      #Change size windows
      "super + alt + {h,j,k,l}" = "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";
      "super + alt + shift + {h,j,k,l}" = "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";
      "super + {Left,Down,Up,Right}" = "bspc node -v {-20 0,0 20,0 -20,20 0}";

      #Shortcuts
      "super + d" = "discord";
      "super + b" = "librewolf";

      #Change desktops
      "super + {parenright,equal}" = "bspc desktop -f {prev,next}";
      "super + {ampersand,eacute,quotedbl,apostrophe,parenleft,minus,egrave,underscore,ccedilla,agrave}" =
        "bspc desktop -f {1,2,3,4,5,6,7,8,9,10}";

      #Move window to another desktop
      "super + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";

      #close/kill app
      "super + {_,shift + }q" = "bspc node -{c,k}";

      #Screenshot
      "super + shift + s" = "maim -s -u | xclip -selection clipboard -t image/png -i";
      "Print" = "maim";
    };
  };
}
