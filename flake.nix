{
  description = "A very basic Flake";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      emacs-overlay = {
        url = "github:nix-community/emacs-overlay";
        flake = false;
      };

      doom-emacs = {
        url = "github:nix-community/nix-doom-emacs";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.emacs-overlay.follows = "emacs-overlay";
      };

      hyprland = {
        url = "github:hyprwm/Hyprland";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      hyprpaper = {
        url = "github:hyprwm/hyprpaper";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      wired = {
        url = "github:Toqozz/wired-notify";
      };
    };

  outputs = inputs @ { self, nixpkgs, home-manager, hyprland, hyprpaper, doom-emacs, wired, ... }:
    let
      user = "klvdmy";
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs user home-manager hyprland hyprpaper doom-emacs wired;
        }
      );
    };
}
