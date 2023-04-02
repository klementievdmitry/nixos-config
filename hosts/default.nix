{ lib, nixpkgs, home-manager, inputs, user, hyprland, hyprpaper, wired, ironbar, ... }:

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
        inherit inputs user system hyprland hyprpaper wired ironbar;
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
            ironbar.homeManagerModules.default
            ./home.nix
            ./laptop/home.nix
          ];
        };
      }
    ];
  };
}
