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
      gdk = pkgs.google-cloud-sdk.withExtraComponents(
        with pkgs.google-cloud-sdk.components; [
            gke-gcloud-auth-plugin
        ]
      );

      # Add mypy plugin to the same venv
      pylsp = pkgs.python3.withPackages(
        p: with p; [
          python-lsp-server
          pylsp-mypy
      ]);
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
          fd
          fzf
          jq
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
          nerdfonts
          # libreoffice

          # MacOS
          yabai
          skhd
          sketchybar

          # Editors
          neovim
          # vscodium-fhs

          # Development Tools

          ## Python
          python311Packages.nox
          python311Packages.black
          python311Packages.ipython
          python311Packages.ipdb
          python311Packages.rich
          pylsp
          ruff
          ruff-lsp
          poetry
          pipx

          ## Databases
          pgcli
          litecli
          sqlite

          ## Other
          gdk
          kubectl
          terraform
          vault
          nmap
          podman
          podman-compose
          yamlfmt
          nodePackages.prettier
          # llm

        ];
      }; 
    };
}
