# Home Manager configuration
{
  inputs,
  config,
  pkgs,
  ...
}: let
  system = pkgs.system;
  nixpkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
  nixpkgs = import inputs.nixpkgs{
    inherit system;
    config.allowUnfree = true;
  };
  gdk = nixpkgs.google-cloud-sdk.withExtraComponents [pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin];
  # pyslp = nixpkgs.python312.withPackages (
  #   p:
  #     with p; [
  #       python-lsp-server
  #       pylsp-mypy
  #     ]
  # );
in {
  home.stateVersion = "25.05";
  home.username = "sauco.navarro";
  home.homeDirectory = "/Users/sauco.navarro";
  home.sessionPath = [
   "$HOME/.local/bin"
  ];
  home.sessionVariables = {
    SHELL = "fish";
    EDITOR = "nvim";
    PYTHONBREAKPOINT = "pdb.set_trace";
    PYTHONSTARTUP = "$HOME/.config/python/pythonrc.py";
    USE_GKE_CLOUD_AUTH_PLUGIN = "True";
    # Maybe rye path
  };

  targets.darwin.keybindings = {
    # Home/End keys behavior
    "\UF729" = "moveToBeginningOfLine:"; # Home
    "\UF72B" = "moveToEndOfLine:"; # End
    "$\UF729" = "moveToBeginningOfLineAndModifySelection:"; # Shift + Home
    "$\UF72B" = "moveToEndOfLineAndModifySelection:"; # Shift + End
    "^\UF729" = "moveToBeginningOfDocument:"; # Ctrl + Home
    "^\UF72B" = "moveToEndOfDocument:"; # Ctrl + End
    "$^\UF729" = "moveToBeginningOfDocumentAndModifySelection:"; # Shift + Ctrl + Home
    "$^\UF72B" = "moveToEndOfDocumentAndModifySelection:"; # Shift + Ctrl + End
  };

  # My Modules
  imports = [
    ./modules/wezterm.nix
    ./modules/starship.nix
    ./modules/fish.nix
    ./modules/neovim.nix
  ];

  home.packages = [
    # nix cli
    nixpkgs.nh

    # Compilers & general build tools
    nixpkgs.gcc
    nixpkgs.cmake

    # Tooling
    nixpkgs.bat
    nixpkgs.fd
    nixpkgs.fzf
    nixpkgs.jq
    nixpkgs.yq-go
    nixpkgs.just
    nixpkgs.lsd
    nixpkgs.procs
    nixpkgs.neofetch
    nixpkgs.magic-wormhole
    nixpkgs.pandoc
    nixpkgs.parallel
    nixpkgs.dust # disk space
    # nixpkgs.pass
    nixpkgs.ripgrep
    nixpkgs.trash-cli
    nixpkgs.sipcalc
    nixpkgs.watch

    # Python
    nixpkgs-unstable.uv
    nixpkgs-unstable.ruff

    # Rust
    nixpkgs.rustup
    # nixpkgs.rustfmt
    # nixpkgs.rust-analyzer

    # Lua
    nixpkgs.stylua

    # Other

    nixpkgs-unstable.claude-code
    nixpkgs-unstable.claude-code-acp
    nixpkgs-unstable.opencode
    # Formatters
    # pkgs.efm-langserver            # langserver to integrate formatters and other cli's
    nixpkgs.nodePackages.prettier #
    nixpkgs.yamlfmt # yaml
    nixpkgs.taplo # toml
    nixpkgs.alejandra # nix

    # Network
    nixpkgs.mtr
    nixpkgs.nmap

    # Infra
    gdk
    nixpkgs.kubectl
    # pkgs.podman-desktop
    # pkgs.podman
    nixpkgs.podman
    nixpkgs.podman-compose
    nixpkgs.terraform
    nixpkgs.vault-bin

    # TUIs
    nixpkgs.htop
    nixpkgs.pgcli
    nixpkgs.litecli
    nixpkgs.sqlite
    nixpkgs.duckdb

    # GUIs
    nixpkgs.slack
    nixpkgs.vscode
    nixpkgs.iina

    # MacOS
    nixpkgs.raycast
  ];

  # SSH
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    extraConfig = ''
      UseKeychain yes
      IdentityFile ~/.ssh/id_ed25519
    '';
  };

  programs.gpg.enable = true;
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
    };
  };

  programs.direnv = {
    enable = true;
    # enableFishIntegration = true;  # defaults to true
    silent = false;
    nix-direnv.enable = true;
  };

  programs.emacs = {
    enable = true;
  };
  #  xdg.configFile.emacs.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/emacs";
  # home.file.".config/emacs" = {
  #   source = ./config/emacs;
  # };

  programs.git = {
    enable = true;
    userEmail = "sauco.navarro@team.wrike.com";
    userName = "sauco";
    extraConfig = {
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      branch = {sort = "-comitterdate";};
      column = {ui = "auto";};
      tag = {sort = "version:refname";};
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        renames = true;
      };
      push = {
        autoSetupRemote = true;
        followTags = true;
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      pull = {rebase = true;};
    };
    ignores = [
      ".venv"
      ".DS_Store"
      "*.pyc"
      ".nox"
      ".idea"
      ".vscode"
      ".pytest_cache"
      ".ruff_cache"
      ".mypy_cache"
      "__pycache__"
      ".direnv"
    ];
  };

  programs.poetry = {
    enable = true;
  };

  programs.k9s = {
    enable = true;
    # aliases = { cj = "cronjobs"; };
  };

  xdg.configFile."k9s/skins/" = {
    source = ./config/k9s/skins;
    recursive = true;
  };

  home.file.".pdbrc.py" = {source = ./.pdbrc.py;};
  xdg.configFile."python/pythonrc.py" = {source = ./config/python/pythonrc.py;};

  # Need to pull the whole config as a whole, no symlinks until this is fixed: https://github.com/FelixKratz/SketchyBar/issues/553
  # config = pkgs.lib.fileContents ./config/sketchybar/sketchybarrc;
  xdg.configFile.sketchybar.source = ./config/sketchybar;
}
