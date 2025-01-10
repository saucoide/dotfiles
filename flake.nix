{
  description = "Sauco's nix system definitions";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url ="github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, home-manager, nixpkgs, nixvim }:
    let 
      baseconfiguration = {pkgs, ...}:{
        nix.channel.enable = false;
        nix.settings.experimental-features = "nix-command flakes";
        nix.settings.substituters = [ 
          "https://cache.nixos.org/"
          "https://devenv.cachix.org"
          "https://nix-community.cachix.org"
        ];
        # nix.settings.trusted-substituters = ;
        nix.settings.trusted-users = [ "sauco.navarro" ];

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 5;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";
	nixpkgs.config.allowUnfree = true;
      };
  in
  {
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
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.users."sauco.navarro" = import ./home.nix;
	  # Optional home-manager.extraSpecialArgs to pass arguments to home.nix
          home-manager.extraSpecialArgs = { inherit inputs; };
          users.users."sauco.navarro" = {
            name = "sauco.navarro";
            home = "/Users/sauco.navarro";
          };
        }

      ];
      specialArgs = { inherit inputs; };
    };
 
    # zima
    # TODO
  };
}
