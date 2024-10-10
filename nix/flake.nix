{
  description = "A flake containing everything I install in profile";

  inputs = {
   nixpkgs23.url = "github:nixos/nixpkgs/nixos-23.05";
   nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
   nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
   # nixpkgs-master.url = "github:nixos/nixpkgs/master";
   # emacs-overlay = {
   #   url = "github:nix-community/emacs-overlay";
   #   inputs.nixpkgs.follows = "nixpkgs";
   # };
  };

  outputs = { self,
              nixpkgs23,
              nixpkgs,
              nixpkgs-unstable,
              # nixpkgs-master,
              # emacs-overlay
            }:
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
      pkgs23 =  import nixpkgs23 { 
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      # pkgs-master = import nixpkgs-master {
      #   inherit system;
      #   config.allowUnfree = true;
      # };
      gdk = pkgs.google-cloud-sdk.withExtraComponents(
        with pkgs.google-cloud-sdk.components; [
            gke-gcloud-auth-plugin
        ]
      );

      # Add mypy plugin to the same venv
      pylsp = pkgs.python311.withPackages(
        p: with p; [
          python-lsp-server
          pylsp-mypy
      ]);
    in 
    {
      packages.${system}.default = pkgs.buildEnv {
        name = "sauco-profile-packages";
        paths = [
          # Nix
          pkgs.nix-direnv
          pkgs.cachix
          # Install devenv separately
          # https://devenv.sh/getting-started/

          # Basics
          pkgs.alacritty
          pkgs.fish
          pkgs.starship
          pkgs.git
          pkgs.ripgrep
          pkgs.just
          pkgs.fd
          pkgs.fzf
          pkgs.jq
          pkgs.lsd
          pkgs.watch
          pkgs.mtr
          pkgs.bat
          pkgs.htop
          pkgs.stow
          pkgs.direnv
          pkgs.pass
          pkgs.parallel
          pkgs.neofetch
          pkgs.trash-cli
          pkgs.sipcalc
          # flameshot
          pkgs.nerdfonts
          pkgs.pandoc
          pkgs23.mpv  # fails on 24.05 because swift doesnt build correctly
          # libreoffice

          # MacOS
          pkgs.yabai
          pkgs.skhd
          pkgs.sketchybar
          pkgs.raycast

          # Editors
          pkgs.neovim
          # vscodium-fhs

          # Development Tools

          ## Python Tools (system-wide)
          pkgs.python312Packages.nox
          pylsp
          pkgs.poetry
          pkgs.pipx
          pkgs.rye
          pkgs-unstable.uv
          pkgs-unstable.ruff
          pkgs-unstable.ruff-lsp

          ## Databases
          pkgs.pgcli
          pkgs.litecli
          pkgs.sqlite

          ## Other
          gdk
          pkgs.kubectl
          pkgs.k9s
          pkgs.terraform
          pkgs.vault-bin
          pkgs.nmap
          pkgs.podman
          pkgs.podman-compose
          pkgs.yamlfmt
          pkgs.nodePackages.prettier
          pkgs.nodePackages.mermaid-cli
          pkgs.taplo
          # pkgs.mermaid-cli
          # llm

        ];
      }; 
    };
}
