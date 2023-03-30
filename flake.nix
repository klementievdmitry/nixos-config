{
  description = "A very basic Flake";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # I don't use emacs-overlay
      emacs-overlay = {
        url = "github:nix-community/emacs-overlay";
        flake = false;
      };

      # I don't use doom-emacs
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

  outputs = inputs @ { self, nixpkgs, home-manager, hyprland, hyprpaper, doom-emacs, wired, emacs-overlay, ... }:
    let
      user = "klvdmy";
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs user home-manager hyprland hyprpaper doom-emacs wired emacs-overlay;
        }
      );
    };
}
