{ config, lib, pkgs, user, system, ... }:

{
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      # Development
      direnv
      rnix-lsp

      # Terminal
      alacritty
      ranger
      helix

      # Video/Audio
      feh
      mpv
      pavucontrol
      plex-media-player
      vlc
      alsa-utils
      rnnoise-plugin

      # Bluetooth
      blueman

      # Apps
      appimage-run
      librewolf
      tor-browser-bundle-bin
      
      # File management
      okular
      pcmanfm
      p7zip
      rsync
      unzip
      unrar
      zip
    ];

    # Emacs conf
    file.".config/emacs" = {
      source = ../modules/emacs;
      recursive = true;
    };

    stateVersion = "22.05";
  };

  services = {
    lorri.enable = true;

    # Enable Emacs as Daemon
    # using home-manager instead of native (for doom support)
    emacs = {
      enable = true;
    };
  };

  programs = {
    home-manager.enable = true;

    emacs = {
      enable = true;
      package = pkgs.emacs;
    };
  };
}
