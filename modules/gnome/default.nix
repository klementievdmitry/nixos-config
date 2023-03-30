{ config, lib, pkgs, ... }:

{
  programs = {
    dconf.enable = true;
    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };

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
        defaultSession = "gnome";
      };
      desktopManager.gnome.enable = true;
    };

    udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
    ];
  };

  hardware.pulseaudio.enable = false;

  environment = {
    systemPackages = with pkgs; [
      gnome.dconf-editor
      gnome.gnome-tweaks
      gnome.adwaita-icon-theme
    ];

    gnome.excludePackages = (with pkgs; [
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      gedit
      epiphany
      geary
      gnome-characters
      tali
      iagno
      hitori
      atomix
      yelp
      gnome-contacts
      gnome-initial-setup
    ]);
  };
}
