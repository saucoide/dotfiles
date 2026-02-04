# Home Manager configuration
{
  inputs,
  config,
  pkgs,
  ...
}:
let
  gdk = pkgs.google-cloud-sdk.withExtraComponents [
    pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
  ];
in
{
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
    MANPAGER = "bat -plman";
    NIXPKGS_ALLOW_UNFREE = "1";
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
    ../../modules/home/clitools.nix
    ../../modules/home/wezterm/wezterm.nix
    ../../modules/home/starship.nix
    ../../modules/home/fish.nix
    ../../modules/home/neovim/neovim.nix
    ../../modules/home/fortune/fortune.nix
    ../../modules/home/python/python.nix
    ../../modules/home/rust/rust.nix
    ../../modules/home/kubernetes/kubernetes.nix
    ../../modules/home/darwin/sketchybar/sketchybar.nix
  ];

  # on macflop wezterm has a bit different config
  wezterm.font_size = 12;
  wezterm.window_decorations = "RESIZE";
  # google cloud
  kubernetes.gcp.enable = true;

  home.packages = [
    # slop
    pkgs.claude-code
    pkgs.codex
    pkgs.opencode
    pkgs.gemini-cli

    (pkgs.writeScriptBin "micronix" (builtins.readFile ../../scripts/micronix.fish))

    # infra
    pkgs.podman-compose
    pkgs.terraform
    pkgs.vault-bin

    # GUIs
    pkgs.zeal
    pkgs.slack
    pkgs.vscode
    pkgs.iina

    # MacOS
    pkgs.raycast
  ];

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  # SSH
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      forwardAgent = false;
      addKeysToAgent = "yes";
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };
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
    enableFishIntegration = true;
    silent = false;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user.email = "sauco.navarro@team.wrike.com";
      user.name = "sauco";
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      branch = {
        sort = "-comitterdate";
      };
      column = {
        ui = "auto";
      };
      tag = {
        sort = "version:refname";
      };
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
      pull = {
        rebase = true;
      };
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
}
