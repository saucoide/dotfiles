{
  description = "saucoides dotfiles flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    nix-config = ./modules/base-nix-config.nix;
  in {
    # ORION
    nixosConfigurations.orion = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        nix-config
        ./machines/orion/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };

    # ZIMA
    nixosConfigurations.zima = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        nix-config
        ./machines/zima/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };

    # MACFLOP
    darwinConfigurations.macflop = inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs;};
      system = "aarch64-darwin";
      modules = [
        nix-config
        ./machines/macflop/configuration.nix
        inputs.home-manager.darwinModules.home-manager
      ];
    };
  };
}
