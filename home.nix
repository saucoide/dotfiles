# Home Manager configuration
{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  gdk = pkgs.google-cloud-sdk.withExtraComponents [pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin];
  pyslp = pkgs.python312.withPackages (
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
    PYTHONSTARTUP = "$HOME/dotfiles/config/python/.pythonrc.py";
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
    ./modules/alacritty.nix
    ./modules/starship.nix
    ./modules/fish.nix
    ./modules/nixvim.nix
  ];

  home.packages = [

    # Compilers & general build tools
    pkgs.gcc
    pkgs.cmake

    # Tooling
    pkgs.bat
    pkgs.fd
    pkgs.fzf
    pkgs.jq
    pkgs.just
    pkgs.lsd
    pkgs.neofetch
    pkgs.magic-wormhole
    pkgs.pandoc
    pkgs.parallel
    pkgs.pass
    pkgs.ripgrep
    pkgs.trash-cli
    pkgs.sipcalc
    pkgs.watch

    # Python
    pkgs.uv
    pkgs.ruff
    pkgs.ruff-lsp
    pyslp

    # Formatters
    # pkgs.efm-langserver            # langserver to integrate formatters and other cli's
    pkgs.nodePackages.prettier #
    pkgs.yamlfmt # yaml
    pkgs.taplo # toml
    pkgs.alejandra # nix

    # Network
    pkgs.mtr
    pkgs.nmap

    # Infra
    gdk
    pkgs.kubectl
    pkgs.podman
    pkgs.podman-compose
    pkgs.terraform
    pkgs.vault-bin

    # TUIs
    pkgs.htop
    pkgs.pgcli
    pkgs.litecli
    pkgs.sqlite

    # GUIs
    pkgs.slack

    # MacOS
    pkgs.raycast
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
      fetch = {prune = true;};
    };
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

  # TODO experiment
  programs.tmux = {
    enable = true;
    shell = "fish";
  };

  # Need to pull the whole config as a whole, no symlinks until this is fixed: https://github.com/FelixKratz/SketchyBar/issues/553
  # config = pkgs.lib.fileContents ./config/sketchybar/sketchybarrc;
  xdg.configFile.sketchybar.source = ./config/sketchybar;
}
