{
  description = "A very basic Flake";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      hyprpaper = {
        url = "github:hyprwm/hyprpaper";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      wired = {
        url = "github:Toqozz/wired-notify";
      };

      helix = {
        url = "github:helix-editor/helix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = inputs @ { self, nixpkgs, home-manager, hyprpaper, wired, helix, ... }:
    let
      user = "ryveti";
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs user home-manager hyprpaper wired helix;
        }
      );
    };
}
