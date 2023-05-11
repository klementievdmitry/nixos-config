{ config, lib, pkgs, user, system, state-version, ... }:

{
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      # Development
      direnv
      python39
      python39Packages.pip

      # Terminal
      alacritty
      ranger
      helix

      # Shell utils
      exa # "ls" replacement written in Rust

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
      discord
      qbittorrent

      # File management
      okular
      pcmanfm
      p7zip
      rsync
      unzip
      unrar
      zip

      # For Zsh
      thefuck
    ];

    # Emacs conf
    file.".config/emacs" = {
      source = ../modules/emacs;
      recursive = true;
    };

    stateVersion = state-version;
  };

  services = {
    lorri.enable = true;
  };

  programs = {
    home-manager.enable = true;

    emacs = {
      enable = true;
    };
  };
}
