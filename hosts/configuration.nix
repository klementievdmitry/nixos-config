{ config, lib, pkgs, user, inputs, home-manager, system, doom-emacs, ... }:

let
in
{
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

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

  fonts.fonts = with pkgs; [
    carlito
    vegur
    source-code-pro
    font-awesome
    corefonts

    jetbrains-mono
    fira-code

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
    gnome.gnome-keyring.enable = true;

    printing = {
      enable = true;
    };

    postgresql = {
      enable = true;
    };

    matrix-synapse = {
      enable = true;
      settings = {
        app_service_config_files = [
          "/var/lib/matrix-synapse/discord-registration.yaml"
        ];
      };
    };

    matrix-appservice-discord = {
      enable = true;
      settings = {
        bridge = {
          domain = "matrix.org";
          homeserverUrl = "https://matrix.org";
        };

        database = {
          filename = "discord.db";
          connString = "socket:/run/postgresql?db=matrix-appservice-discord";
        };

        room.defaultVisibility = "public";
        
        channel = {
          namePattern = "[Discord] :guild :name";
          deleteOptions = {
            disableMessaging = false;
            unserRoomAlias = true;
            unlistFromDirectory = true;
            setInviteOnly = true;
            ghostsLeave = true;
          };
        };
      };
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

      config.pipewire = {
        "context.properties" = {
          "log.level" = 0;
        };

        "context.spa-libs" = {
          "audio.convert.*" = "audio/libspa-audioconvert";
          "support.*" = "support/libspa-support";
        };

        "context.modules" = [
          {
            name = "libpipewire-module-rtkit";
            args = {
              "nice.level" = -11;
              "rt.prio" = 88;
              "rt.time.soft" = 200000;
              "rt.time.hard" = 200000;
            };
            flags = [ "ifexists" "nofail" ];
          }
          { name = "libpipewire-module-protocol-native"; }
          { name = "libpipewire-module-profiler"; }
          { name = "libpipewire-module-metadata"; }
          { name = "libpipewire-module-spa-device-factory"; }
          { name = "libpipewire-module-spa-node-factory"; }
          { name = "libpipewire-module-client-node"; }
          { name = "libpipewire-module-client-device"; }
          {
            name = "libpipewire-module-portal";
            flags = [ "ifexists" "nofail" ];
          }
          {
            name = "libpipewire-module-access";
            args = { };
          }
          { name = "libpipewire-module-adapter"; }
          { name = "libpipewire-module-link-factory"; }
          { name = "libpipewire-module-session-manager"; }
          {
            name = "libpipewire-module-filter-chain";
            args = {
              "node.description" = "Noise Canceling source";
              "media.name" = "Noise Canceling source";
              "filter.graph" = {
                "nodes" = [
                  {
                    "type" = "ladspa";
                    "name" = "rnnoise";
                    "plugin" = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                    "label" = "noise_suppressor_mono";
                    "control" = {
                      "VAD Threshold (%)" = 50.0;
                      "VAD Grace Period (ms)" = 200;
                      "Retroactive VAD Grace (ms)" = 0;
                    };
                  }
                ];
              };

              "capture.props" = {
                "node.name" = "capture.rnnoise_source";
                "node.passive" = true;
                "audio.rate" = 48000;
              };

              "playback.props" = {
                "node.name" = "rnnoise_source";
                "media.class" = "Audio/Source";
                "audio.rate" = 48000;
              };
            };
          }
        ];
      };
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

  system = {
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "22.05";
  };
}
