# Home Manager configuration
{
  inputs,
  config,
  pkgs,
  ...
}: let
  system = pkgs.system;
  # TODO move everything from pkgs to pkgs-unstable
  nixpkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  nixpkgs-stable = import inputs.nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };
  gdk = nixpkgs.google-cloud-sdk.withExtraComponents [pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin];
  pyslp = nixpkgs.python312.withPackages (
    p:
      with p; [
        python-lsp-server
        pylsp-mypy
      ]
  );
  # emacs-overlay = import ( fetchTarBall {
  #   url = ;
  #   sha256 = ;
  # });
  # customEmacs = pkgs.emacs30.override {
  #   withNativeCompilation = true;
  #   withSQLite3 = true;
  #   withTreeSitter = true;
  #   withImageMagick = true;
  # };
in {
  home.stateVersion = "24.11";
  home.username = "sauco.navarro";
  home.homeDirectory = "/Users/sauco.navarro";
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
    inputs.nixvim.homeManagerModules.nixvim
    ./modules/wezterm.nix
    ./modules/starship.nix
    ./modules/fish.nix
    ./modules/nixvim.nix
  ];

  home.packages = [
    # Compilers & general build tools
    nixpkgs-stable.gcc
    nixpkgs-stable.cmake

    # Tooling
    nixpkgs-stable.bat
    nixpkgs-stable.fd
    nixpkgs-stable.fzf
    nixpkgs-stable.jq
    nixpkgs-stable.just
    nixpkgs-stable.lsd
    nixpkgs-stable.procs
    nixpkgs-stable.neofetch
    nixpkgs-stable.magic-wormhole
    nixpkgs-stable.pandoc
    nixpkgs-stable.parallel
    nixpkgs-stable.dust # disk space
    # nixpkgs-stable.pass
    nixpkgs-stable.ripgrep
    nixpkgs-stable.trash-cli
    nixpkgs-stable.sipcalc
    nixpkgs-stable.watch

    # Python
    nixpkgs.uv
    nixpkgs.ruff
    pyslp

    nixpkgs.claude-code
    nixpkgs.opencode
    # Formatters
    # pkgs.efm-langserver            # langserver to integrate formatters and other cli's
    nixpkgs-stable.nodePackages.prettier #
    nixpkgs-stable.yamlfmt # yaml
    nixpkgs-stable.taplo # toml
    nixpkgs-stable.alejandra # nix

    # Network
    nixpkgs-stable.mtr
    nixpkgs-stable.nmap

    # Infra
    gdk
    nixpkgs-stable.kubectl
    # pkgs.podman-desktop
    # pkgs-stable.podman
    nixpkgs.podman
    nixpkgs.podman-compose
    nixpkgs-stable.terraform
    nixpkgs-stable.vault-bin

    # TUIs
    nixpkgs-stable.htop
    nixpkgs-stable.pgcli
    nixpkgs-stable.litecli
    nixpkgs-stable.sqlite

    # GUIs
    nixpkgs-stable.slack
    nixpkgs.vscode
    nixpkgs.iina

    # MacOS
    nixpkgs-stable.raycast
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

  #  programs.emacs = {
  #    enable = true;
  #    package = pkgs.emacs30;
  #  };
  #  xdg.configFile.emacs.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/emacs";
  # home.file.".config/emacs" = {
  #   source = ./config/emacs;
  # };

  programs.git = {
    enable = true;
    userEmail = "sauco.navarro@team.wrike.com";
    userName = "sauco";
    extraConfig = {
      fetch = { prune = true; pruneTags = true; all = true;};
      branch = { sort = "-comitterdate";};
      column = { ui = "auto";};
      tag = { sort = "version:refname";};
      diff = { algorithm = "histogram"; colorMoved = "plain"; renames = true;};
      push = { autoSetupRemote = true; followTags = true;};
      rerere = {enabled = true; autoupdate = true;};
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

  home.file.".pdbrc.py" = { source = ./.pdbrc.py; };
  xdg.configFile."python/pythonrc.py" = { source = ./config/python/pythonrc.py; };

  # Need to pull the whole config as a whole, no symlinks until this is fixed: https://github.com/FelixKratz/SketchyBar/issues/553
  # config = pkgs.lib.fileContents ./config/sketchybar/sketchybarrc;
  xdg.configFile.sketchybar.source = ./config/sketchybar;
}
