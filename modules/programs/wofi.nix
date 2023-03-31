#
# System Menu
#

{ config, lib, pkgs, ... }:

let
  inherit (config.lib.formats.rasi) mkLiteral;        # Theme.rasi alternative. Add Theme here
  colors = import ../themes/colors.nix;
in
{
  home = {
    packages = with pkgs; [
      wofi
    ];
  };

  home.file = {
    ".config/wofi/config" = {
      text = ''
        width=280
        lines=10
        xoffset=5
        yoffset=5
        location=1
        prompt=Search...
        filter_rate=100
        allow_markup=false
        no_actions=true
        halign=fill
        orientation=vertical
        content_halign=fill
        insensitive=true
        allow_images=true
        image_size=20
        hide_scroll=true
      '';
    };
    ".config/wofi/style.css" = with colors.scheme.doom; {
      text = ''
        window {
          margin: 0px;
          background-color: #${bg};
          background: transparent;
        }

        #input {
          all: unset;
          min-height: 20px;
          padding: 4px 10px;
          margin: 4px;
          border: 3px solid #${text};
          border-radius: 0px;
          color: #dfdfdf;
          font-weight: bold;
          background-color: #${bg};
          outline: #dfdfdf;
        }

        #inner-box {
          font-weight: bold;
          border-radius: 0px;
        }

        #text:selected {
          color: #282c34;
        }

        #entry {
          margin-bottom: 2px;
          background-color: #${bg};
        }

        #entry:selected {
          background-color: #${text};
        }
      '';
    };
    ".config/wofi/power.sh" = with colors.scheme.doom; {
      executable = true;
      text = ''
        #!/bin/sh

        entries="⏾ Suspend\n⭮ Reboot\n⏻ Shutdown"

        selected=$(echo -e $entries|wofi --dmenu --cache-file /dev/null | awk '{print tolower($2)}')

        case $selected in
          suspend)
            exec systemctl suspend;;
          reboot)
            exec systemctl reboot;;
          shutdown)
            exec systemctl poweroff -i;;
        esac
      '';
    };
  };
}
