{
  description = "saucoides dotfiles flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # autofirma-nix = {
    #   url = "github:nix-community/autofirma-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      nix-config = ./modules/base-nix-config.nix;

      overlays = [
        (final: prev: {
          teamcity-cli = final.callPackage ./pkgs/teamcity-cli.nix { };
          unstable = import inputs.nixpkgs-unstable {
            inherit (prev.stdenv.hostPlatform) system;
            inherit (prev) config;
          };
        })
      ];
    in
    {
      overlays.default = nixpkgs.lib.composeManyExtensions overlays;

      # Project templates: `nix flake init -t ~/dotfiles#rust`
      templates = {
        rust = {
          path = ./templates/rust;
          description = "Rust dev shell";
        };
        python = {
          path = ./templates/python;
          description = "Python dev shell";
        };
        default = self.templates.python;
      };

      # ORION
      nixosConfigurations.orion = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          nix-config
          ./machines/orion/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      # ZIMA
      nixosConfigurations.zima = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          nix-config
          ./machines/zima/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      # MACFLOP
      darwinConfigurations.macflop = inputs.nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        system = "aarch64-darwin";
        modules = [
          nix-config
          ./machines/macflop/configuration.nix
          inputs.home-manager.darwinModules.home-manager
        ];
      };

      # MICROVMS
      # micronix - ephemeral to mount arbitrary dirs
      nixosConfigurations.micronix = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs;
          # darwin pkgs for the VM runner (vfkit on macOS)
          hostPkgs = nixpkgs.legacyPackages.aarch64-darwin;
        };
        modules = [
          inputs.microvm.nixosModules.microvm
          { nixpkgs.overlays = [ self.overlays.default ]; }
          ./machines/microvms/micronix.nix
        ];
      };
    };
}
