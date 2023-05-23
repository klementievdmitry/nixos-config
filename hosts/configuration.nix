{ config, lib, pkgs, user, inputs, home-manager, system, state-version, ... }:

let
in
{
  networking = {
    networkmanager = {
      enable = true;
    };
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      l = "${pkgs.exa}/bin/exa -aal";
      ll = "${pkgs.exa}/bin/exa -l";
      update = "sudo nixos-rebuild switch";
    };
    histSize = 10000;
    histFile = "$HOME/.zsh_history";
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
      theme = "robbyrussell";
    };
  };

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
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

  fonts.fonts = with pkgs; [
    # Core fonts
    carlito
    vegur
    source-code-pro
    font-awesome
    corefonts

    # Main fonts
    jetbrains-mono
    fira-code

    # Icons for Emacs
    emacs-all-the-icons-fonts

    (nerdfonts.override {
      fonts = [
        "FiraCode"
      ];
    })
  ];

  environment = {
    variables = {
      TERMINAL = "alacritty";
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
      mc # Terminal file manager
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

    tor = {
      enable = false;
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
    registry.nixpkgs.flake = inputs.nixpkgs-stable;

    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  system = {
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-${state-version}";
    };
    stateVersion = state-version;
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };

      grub = {
        efiSupport = true;
        device = "nodev";
      };

      timeout = 1;
    };
  };
 
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
    };
    overlays = [
      (self: super: {
        discord = super.discord.overrideAttrs (
          _: {
            src = builtins.fetchTarball {
              url = "https://discord.com/api/download?platform=linux&format=tar.gz";
              sha256 = "0mr1az32rcfdnqh61jq7jil6ki1dpg7bdld88y2jjfl2bk14vq4s";
            };
          }
        );
      })
    ];
  }; 

  # HIP for programs like Blender
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
  ];

  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];

  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
  };

  security.polkit.enable = true;
}
