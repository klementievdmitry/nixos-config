{ lib, nixpkgs-stable, home-manager, inputs, user, state-version, ... }:

let
  system = "x86_64-linux";

  pkgs = import nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs-stable.lib;
in
{
  desktop = lib.nixosSystem {
    inherit system;
    specialArgs = {
      # Configuration special args
      inherit inputs user system state-version;

      host = {
        hostName = "desktop";
      };
    };
    modules = [
      ./desktop
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          # Home-manager special args
          inherit user state-version;

          host = {
            hostName = "desktop";
          };
        };
        home-manager.users.${user} = {
          imports = [
            ./home.nix
            ./desktop/home.nix
          ];
        };
      }
    ];
  };
  
  laptop = lib.nixosSystem {
    inherit system;
    specialArgs = {
      # Configuration special args
      inherit inputs user system state-version;

      host = {
        hostName = "laptop";
      };
    };
    modules = [
      ./laptop
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          # Home-manager special args
          inherit user state-version;

          host = {
            hostName = "laptop";
          };
        };
        home-manager.users.${user} = {
          imports = [
            ./home.nix
            ./laptop/home.nix
          ];
        };
      }
    ];
  };
}
