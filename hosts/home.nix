{ config, lib, pkgs, user, doom-emacs, wired, ... }:

{
  imports =
    ( import ../modules/programs ) ++
    [ doom-emacs.hmModule ];

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      # Development
      rustup
      rust-analyzer
      clang

      # Terminal
      wezterm
      btop
      nitch
      ranger
      tldr

      # Video/Audio
      feh
      mpv
      pavucontrol
      plex-media-player
      vlc
      stremio

      # Bluetooth
      blueman

      # Apps
      appimage-run
      firefox
      google-chrome
      remmina
      discord

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

    stateVersion = "22.05";
  };

  services = {
    # Enable Emacs as Daemon
    # using home-manager instead of native (for doom support)
    emacs.enable = true;
  };

  programs = {
    home-manager.enable = true;

    doom-emacs = {
      enable = true;
      doomPrivateDir = ../modules/doom.d;
    };
  };

  gtk = {                                     # Theming
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
    };                                        # Cursor is declared under home.pointerCursor
  };

  systemd.user.targets.tray = {               # Tray.target can not be found when xsession is not enabled. This fixes the issue.
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
}
