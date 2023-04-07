{ config, lib, pkgs, user, wired, ... }:

{
  imports =
    (import ../modules/programs);

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      # For emacs
      w3m

      # Development
      direnv

      # Terminal
      alacritty
      btop
      nitch
      ranger
      tldr

      # System utils
      inxi
      lm_sensors
      gparted
      
      # Video/Audio
      feh
      mpv
      pavucontrol
      plex-media-player
      vlc
      stremio
      alsa-utils
      pulseaudio
      rnnoise-plugin

      # Bluetooth
      blueman

      # Apps
      appimage-run
      firefox
      google-chrome
      remmina
      discord
      tor-browser-bundle-bin
      
      # Disk management
      #gparted
      btrfs-progs

      # File management
      gnome.file-roller
      okular
      pcmanfm
      p7zip
      rsync
      unzip
      unrar
      zip
    ];

    file.".config/wall.jpg".source = ../modules/themes/wall.jpg;

    # Emacs conf
    file.".emacs.d" = {
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

  gtk = {
    # Theming
    enable = true;
    theme = {
      name = "Dracula";
      #name = "Catppuccin-Mocha-Compact-Mauve-Dark";
      package = pkgs.dracula-theme;
      #package = pkgs.catppuccin-gtk.override {
      #  accents = ["mauve"];
      #  size = "compact";
      #  variant = "mocha";
      #};
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      #name = "JetBrains Mono Medium";
      name = "FiraCode Nerd Font Mono Medium";
    }; # Cursor is declared under home.pointerCursor
  };

  systemd.user.targets.tray = {
    # Tray.target can not be found when xsession is not enabled. This fixes the issue.
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
}
