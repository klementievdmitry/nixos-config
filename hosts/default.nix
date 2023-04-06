{ lib, nixpkgs, home-manager, inputs, user, hyprland, hyprpaper, wired, ... }:

let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
  laptop = lib.nixosSystem {
    inherit system;
    specialArgs = {
        inherit inputs user system hyprland hyprpaper wired;
      host = {
        hostName = "laptop";
      };
    };
    modules = [
      hyprland.nixosModules.default
      ./laptop
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit user;
          host = {
            hostName = "laptop";
          };
        };
        home-manager.users.${user} = {
          imports = [
            hyprland.homeManagerModules.default
            ./home.nix
            ./laptop/home.nix
          ];
        };
      }
    ];
  };
  
  desktop = lib.nixosSystem {
    inherit system;
    specialArgs = {
        inherit inputs user system hyprland hyprpaper wired;
      host = {
        hostName = "desktop";
      };
    };
    modules = [
      hyprland.nixosModules.default
      ./desktop
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit user;
          host = {
            hostName = "desktop";
          };
        };
        home-manager.users.${user} = {
          imports = [
            hyprland.homeManagerModules.default
            ./home.nix
            ./desktop/home.nix
          ];
        };
      }
    ];
  };
}
