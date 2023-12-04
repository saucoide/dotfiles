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
        config.allowUnfree = true;
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
          # Nix
          nix-direnv
          cachix
          # Install devenv separately
          # https://devenv.sh/getting-started/

          # Basics
          alacritty
          fish
          starship
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
          trash-cli
          flameshot
          # libreoffice

          # MacOS
          yabai
          skhd
          sketchybar

          # Editors
          neovim
          # emacs29   # i switched to install this from brew instead
          # emacsPackages.vterm
          # libvterm
          # vscodium-fhs

          # Development Tools

          ## Python
          python3
          python311Packages.nox
          python311Packages.black
          python311Packages.python-lsp-server
          python311Packages.python-lsp-ruff
          python311Packages.ipython
          python311Packages.ipdb
          python311Packages.rich
          ruff
          ruff-lsp
          poetry
          mypy
          pipx

          ## Databases
          pgcli
          litecli
          sqlite

          ## Other
          google-cloud-sdk
          terraform
          podman
          podman-compose
          jq
          yamlfmt
          nodePackages.prettier
          # llm

        ];
      }; 
    };
}
