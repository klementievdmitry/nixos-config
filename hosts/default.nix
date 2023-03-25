{ lib, nixpkgs, home-manager, inputs, user, doom-emacs, ... }:

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
      inherit inputs user system;
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
          inherit user doom-emacs;
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
