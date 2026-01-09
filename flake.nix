{
  description = "Sauco's nix system definitions";
  inputs = {
    nixpkgs-unstable = {url = "github:NixOS/nixpkgs/nixpkgs-unstable";};
    nixpkgs = {url = "github:NixOS/nixpkgs/nixos-25.11";};
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs-unstable,
    nixpkgs,
    nix-darwin,
    home-manager,
  }: let
    baseconfiguration = {...}: {
      nix.channel.enable = false;
      nix.settings.experimental-features = "nix-command flakes";
      nix.settings.substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org/"
      ];
      nix.settings.trusted-substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org/"
      ];
      nix.settings.trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      nix.settings.trusted-users = ["sauco.navarro"];

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      nixpkgs.config.allowUnfree = true;
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .macflop)

    # macflop
    darwinConfigurations.prgm-snavarro4 = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        # nix itself config
        baseconfiguration
        # MacOS system config
        ./darwin.nix
        # home-manager config
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.users."sauco.navarro" = import ./home.nix;
          # Optional home-manager.extraSpecialArgs to pass arguments to home.nix
          home-manager.extraSpecialArgs = {inherit inputs;};
          users.users."sauco.navarro" = {
            name = "sauco.navarro";
            home = "/Users/sauco.navarro";
          };
        }
      ];
      specialArgs = {inherit inputs;};
    };
  };
}
