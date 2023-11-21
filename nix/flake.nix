{
  description = "A flake containing everything I install in profile";

  inputs = {
   nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
   # emacs-overlay = {
   #   url = "github:nix-community/emacs-overlay";
   #   inputs.nixpkgs.follows = "nixpkgs";
   # };
  };

  outputs = { self, nixpkgs, emacs-overlay }:
    let
      system = "x86_64-darwin";
      pkgs =  import nixpkgs { 
        inherit system;
   # Not using the emacs overlays anymore - could not get this
   # to work nicely with yabai
   #     overlays = [
   #       (import emacs-overlay)
   #       (import ./overlays/emacs.nix)
   #     ];
      };
    in 
    {
      packages.${system}.default = pkgs.buildEnv {
        name = "sauco-profile-packages";
        paths = with pkgs; [
          # Basics
          fish
          git
          ripgrep
          lsd
          bat
          htop
          stow
          direnv
          pass
          parallel
          neofetch

          # MacOS
          yabai
          skhd
          sketchybar

          # Nix
          nix-direnv
          cachix
          # Install devenv separately
          # https://devenv.sh/getting-started/

          # Python tools
          python311Packages.nox
          python311Packages.black

          # Node tools
          nodePackages.prettier

          # Editors
          neovim
          # emacs29   # i switched to install this from brew instead

          # Other tools
          flameshot
          jq
          yamlfmt
        ];
      }; 
    };
}
