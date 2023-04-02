{ config, lib, pkgs, ... }:

{
  imports =
    [ ../programs/waybar.nix ] ++
    [ ../programs/wired.nix ] ++
    [ ../programs/hyprpaper.nix ] ++
    [ ../programs/swaylock.nix ];

  hardware.opengl.enable = true;

  services = {
    xserver = {
      enable = true;

      layout = "us, de, ru";
      xkbOptions = "grp:caps_toggle";
      libinput.enable = true;
      modules = [ pkgs.xf86_input_wacom ];
      wacom.enable = true;

      displayManager = {
        gdm.enable = true;
	defaultSession = "sway";
      };
    };
  };

  programs = {
    sway = {
      enable = true;
      extraPackages = with pkgs; [
       autotiling # Tiling script
       wev        # Input viewer
       wl-clipboard # CL Clipboard
       wlr-randr
       xwayland
      ];
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
