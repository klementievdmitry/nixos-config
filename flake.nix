{
  description = "Description?!";

  inputs =
    {
      stable.url = "github:nixos/nixpkgs/nixos-22.11";

      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "stable";
      };
    };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }:
    let
      # User X
      user = "x";
      
      # Using variable for state version
      state-version = "22.11";
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
