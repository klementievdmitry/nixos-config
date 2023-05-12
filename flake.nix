{
  description = "Description?!";

  inputs =
    let
      # Using variable for state version
      state-version = "23.05";
    in
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-${state-version}";

      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }:
    let
      # User X
      user = "x";
      
      # Using variable for state version
      state-version = "23.05";
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs user home-manager state-version;
        }
      );
    };
}
