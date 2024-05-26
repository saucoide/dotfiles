{ config, pkgs, ... }:

let 
  # gcloud extra components
  gdk = pkgs.google-cloud-sdk.withExtraComponents(
    with pkgs.google-cloud-sdk.components; [
      gke-gcloud-auth-plugin
    ]
  );

  # Add mypy plugin to the same venv
  pylsp = pkgs.python312.withPackages(
    p: with p; [
      python-lsp-server
      pylsp-mypy
    ]);

in {
  home.username = "saucoide";
  home.homeDirectory = "/home/saucoide";
  home.stateVersion = "23.11"; # Please read the comment before changing.

  
  # Packages
  home.packages = with pkgs; [

    # Nix
    nix-direnv
    cachix
    # Install devenv separately
    # https://devenv.sh/getting-started/
    
    # Core Tools
    htop
    lshw
    ripgrep
    fd
    fzf

    cowsay
    # Basics
    #  alacritty
    #  fish
    #  starship
    #  git
    just
    jq
    #   lsd
    #   watch
    #   bat
    #   htop
    #   stow
    #   direnv
    #   pass
    parallel
    #   neofetch
    #   trash-cli
    #   flameshot
    #   nerdfonts
    # libreoffice

    # Editors
    #   neovim
    # vscodium-fhs

    # Development Tools

    ## Python
    python312Packages.nox
    python312Packages.black
    python312Packages.ipython
    python312Packages.ipdb
    python312Packages.rich
    pylsp
    ruff
    ruff-lsp
    #  poetry
    #  pipx

    ## Databases
    pgcli
    litecli
    sqlite

    ## Other
    gdk
    kubectl
    terraform
    #    vault
    nmap
    podman
    podman-compose
    yamlfmt
    nodePackages.prettier
    # llm

  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    LOCALE_ARCHIVE = "$HOME/.nix-profile/lib/locale/locale-archive";
    EDITOR = "emacsclient";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
