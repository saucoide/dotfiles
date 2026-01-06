{
  description = "saucoides dotfiles flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
	nur = {
	  url = "github:nix-community/NUR";
	  inputs.nixpkgs.follows = "nixpkgs";
	};
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.zima = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./machines/zima/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };
  };
}
