{
  description = "Description?!";

  inputs =
    {
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.11";

      home-manager = {
        url = "github:nix-community/home-manager/release-22.11";
        inputs.nixpkgs.follows = "nixpkgs-stable";
      };
    };

  outputs = inputs @ {
    self,
    nixpkgs-stable,
    home-manager,
    ...
  }:
  let
    # User X
    user = "x";
    
    # Using variable for state version
    state-version = "22.11";
  in
  {
    nixosConfigurations = (
      import ./hosts {
        inherit (nixpkgs-stable) lib;
        inherit inputs nixpkgs-stable user home-manager state-version;
      }
    );
  };
}
