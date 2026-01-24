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
  } @ inputs: {
    # ZIMA
    nixosConfigurations.zima = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./machines/zima/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };

    # MACFLOP
    darwinConfigurations.macflop = inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs;};
      system = "aarch64-darwin";
      modules = [
        ./machines/macflop/configuration.nix
        inputs.home-manager.darwinModules.home-manager
      ];
    };
  };
}
