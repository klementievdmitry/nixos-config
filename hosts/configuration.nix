{ config, lib, pkgs, user, inputs, home-manager, ... }:

{
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.nushell;
  };
  security.sudo.wheelNeedsPassword = false; # User doesn't need password when using sudo

  time.timeZone = "Asia/Yekaterinburg";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "ru_RU.UTF-8";
      LC_MONETARY = "ru_RU.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  security.rtkit.enable = true;
  security.polkit.enable = true;

  fonts.fonts = with pkgs; [
    carlito
    vegur
    source-code-pro
    jetbrains-mono
    font-awesome
    corefonts
    (nerdfonts.override {
      fonts = [
        "FiraCode"
      ];
    })
  ];

  environment = {
    variables = {
      TERMINAL = "wezterm";
      EDITOR = "emacs";
      VISUAL = "emacs";
    };

    systemPackages = with pkgs; [
      git
      killall
      nano
      pciutils
      usbutils
      wget
    ];

    etc = {
      "wireplumber/policy.lua.d/11-bluetooth-policy.lua".text = ''
        bluetooth_policy.policy["media-role.use-headset-profile"] = false
      '';
    };
  };

  services = {
    printing = {
      enable = true;
    };

    avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
        addresses = true;
        userServices = true;
      };
    };

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };

    openssh = {
      enable = true;
      allowSFTP = true;
      extraConfig = ''
        HostKeyAlgorithms +ssh-rsa
      '';
    };

    flatpak.enable = true;
  };

  hardware = {
    bluetooth = {
      enable = true;
      hsphfpd.enable = false;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
  };

  nix = {
    settings = {
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };

    package = pkgs.nixVersions.unstable;
    registry.nixpkgs.flake = inputs.nixpkgs;

    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };
  nixpkgs.config.allowUnfree = true;

  system = {
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "22.05";
  };
}
