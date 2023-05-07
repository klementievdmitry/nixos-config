{ config, lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    layout = "us, ru";
    xkbOptions = "grp:win_space_toggle";
    windowManager.bspwm = {
      enable = true;
    };
    displayManager = {
      defaultSession = "none+bspwm";
      lightdm = {
        enable = true;
        greeter.enable = true;
      };
    };
  };
  
  services.picom = {
    enable = true;
    vSync = true;
    activeOpacity = 1.0;
    inactiveOpacity = 0.95;
    opacityRules = [
      # always make terminals slightly transparent
      "90:class_g = 'Alacritty' && focused"
      "85:class_g = 'Alacritty' && !focused"
    ];
    fade = true;
    fadeDelta = 5;
    # this was the thing that made the tearing go away!
    backend = "glx";
  };
}
