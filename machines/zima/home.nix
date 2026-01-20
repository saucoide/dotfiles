{
  config,
  pkgs,
  ...
}: {
  home.username = "saucoide";
  home.homeDirectory = "/home/saucoide";

  home.sessionVariables = {
    SHELL = "fish";
    EDITOR = "nvim";
    XDG_CURRENT_DESKTOP = "sway";
  };
  xdg.userDirs = {
    enable = true;
    createDirectories = false;
    desktop = "${config.home.homeDirectory}/desktop";
    download = "${config.home.homeDirectory}/downloads";
    documents = "${config.home.homeDirectory}/documents";
    pictures = "${config.home.homeDirectory}/pictures";
    videos = "${config.home.homeDirectory}/videos";
    extraConfig = {
      XDG_PROJECTS_DIR = "${config.home.homeDirectory}/projects";
      XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/screenshots";
    };
  };

  imports = [
    ../../modules/home/sway
    ../../modules/home/fish.nix
    ../../modules/home/starship.nix
    ../../modules/home/neovim/neovim.nix
    ../../modules/home/python/python.nix
    ../../modules/home/wezterm/wezterm.nix
    ../../modules/home/firefox/firefox.nix
    # ../../modules/home/kubernetes/kubernetes.nix
    ../../modules/home/gtk.nix
    ../../modules/home/custom-scripts.nix
  ];

  # enable/disable imported module options
  modules.sway.kanshi.enable = true;

  home.packages = [
    # TODO - group all this stuff into separate modules, they get merged anyway int the end
    pkgs.gcc
    pkgs.cmake
    pkgs.gnumake

    # general tools
    pkgs.bat # cat replacement
    pkgs.fd # find replacement
    pkgs.fzf # fuzzy finder
    pkgs.jq
    pkgs.yq-go # jq like
    pkgs.just # command runner
    pkgs.lsd # ls replacement
    pkgs.procs # ps replacement
    pkgs.magic-wormhole # send/receive
    pkgs.pandoc # doc converter
    pkgs.dust # disk space
    pkgs.ripgrep # grep replacement
    pkgs.trash-cli
    pkgs.htop
    pkgs.bottom

    # network tools
    pkgs.mtr
    pkgs.nmap

    # infrastructure tools
    pkgs.podman

    # database tools
    # pkgs.sqlite
    # pkgs.litecli
    # pkgs.pgcli
    # pkgs.duckdb

    # other languages
    pkgs.stylua
    pkgs.yamlfmt
    pkgs.taplo
    pkgs.alejandra
    pkgs.nodePackages.prettier

    # Video
    pkgs.ffmpeg

    # Images
    pkgs.loupe # basic image viewer
    pkgs.gthumb # basic image editor
    pkgs.gimp # advanced image editor
    pkgs.snapshot # webcam

    # GUI Programs
    pkgs.signal-desktop
    pkgs.prusa-slicer
    pkgs.mpv
    pkgs.celluloid
    pkgs.libreoffice
  ];

  services.udiskie.enable = true; # mounting usb drives (requires usdisks2 systemwide)

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
      IdentityFile ~/.ssh/id_ed25519
    '';
  };

  services.ssh-agent = {
    enable = true;
    enableFishIntegration = true;
    defaultMaximumIdentityLifetime = 600;
  };

  programs.gpg.enable = true;
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "saucoide";
        email = "saucoide@gmail.com";
      };
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
      "*.pyc"
      ".nox"
      ".idea"
      ".vscode"
      ".pytest_cache"
      ".ruff_cache"
      ".mypy_cache"
      "__pycache__"
      ".direnv"
      ".DS_Store"
    ];
  };

  programs.direnv = {
    enable = true;
    # enableFishIntegration = true;
    silent = false;
    nix-direnv.enable = true;
  };

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

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.
  programs.home-manager.enable = true;
}
