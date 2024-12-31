# Home Manager configuration
{ config, pkgs, lib, ...}: 
let 
  gdk = pkgs.google-cloud-sdk.withExtraComponents(
    [pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin]
  );
  pyslp = pkgs.python312.withPackages(
    p: with p; [
      python-lsp-server
      pylsp-mypy
    ]
  );
  # emacs-overlay = import ( fetchTarBall {
  #   url = ;
  #   sha256 = ;
  # });
  customEmacs = pkgs.emacs30.override {
    withNativeCompilation = true;
    withSQLite3 = true;
    withTreeSitter = true;
    withImageMagick = true;
  };
in
 {
  
  home.stateVersion = "24.11";
  home.username = "sauco.navarro";
  home.homeDirectory = "/Users/sauco.navarro";
  home.sessionVariables = {
    EDITOR = ''emacsclient -a nvim -t "$@"'';
    PYTHONBREAKPOINT = "pdb.set_trace";
    PYTHONSTARTUP = "$HOME/dotfiles/config/python/.pythonrc.py";
    USE_GKE_CLOUD_AUTH_PLUGIN = "True";
    # Maybe rye path
  };

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
    pkgs.nodePackages.prettier
    pkgs.yamlfmt
    pkgs.taplo

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


  # ALACRITTY
  programs.alacritty = {
    enable = true;
    settings = {
      env = { TERM = "xterm-256color";};
      terminal.shell = {program = "${pkgs.fish}/bin/fish";};
      window = {
        decorations = "buttonless";
        dynamic_padding = false;
        opacity = 1.0;
        title = "alacritty";
        padding = {x = 6; y = 6;};
      };
      scrolling = { history = 10000; };
      font = {
        size = 12.0;
        offset = {x = 0; y = 1;};
        normal = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Bold";
        };
        bold_italic = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Bold Italic";
        };
        italic = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Italic";
        };
      };
     
      colors = {
        draw_bold_text_with_bright_colors = true;
        primary = {
          background = "#2D2A2E";
          foreground = "#FCFCFA";
        };
        normal = {
          black="#403E41";
          blue="#FC9867";
          cyan="#78DEC8";
          green="#A9DC76";
          magenta="#AB9DF2";
          red="#FF6188";
          white="#FCFCFA";
          yellow="#FFD866";
        };
        bright = {
          black="#727072";
          blue="#FC9867";
          cyan="#78DEC8";
          green="#A9DC76";
          magenta="#AB9DF2";
          red="#FF6188";
          white="#FCFCFA";
          yellow="#FFD866";
        };
      };
      keyboard = {
        bindings = [
          {action="Copy"; key="C"; mods="Control|Shift";}
          {action="Copy"; key="Copy"; mods="None";}
          {action="Paste"; key="V"; mods="Control|Shift";}
          {action="Paste"; key="Paste"; mods="None";}
          {action="PasteSelection"; key="Insert"; mods="Shift";}
          {action="ResetFontSize"; key="Key0"; mods="Control";}
          {action="IncreaseFontSize"; key="Equals"; mods="Control";}
          {action="IncreaseFontSize"; key="Plus"; mods="Control";}
          {action="DecreaseFontSize"; key="Minus"; mods="Control";}
          {action="ToggleFullScreen"; key="F11"; mods="None";}
          {action="ClearLogNotice"; key="L"; mods="Control";}
          {chars="\\f"; key="L"; mods="Control";}
          {action="ScrollPageUp"; key="PageUp"; mods="None"; mode="~Alt";}
          {action="ScrollPageDown"; key="PageDown"; mods="None"; mode="~Alt";}
          {action="ScrollToTop"; key="Home"; mods="Shift"; mode="~Alt";}
          {action="ScrollToBottom"; key="End"; mods="Shift"; mode="~Alt";}
        ];
      };
    };
  };


  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Get most envvars from .profile (requires oh-my-fish & fenv)
      # fenv source $HOME/.profile   # TODO .profile
      source $HOME/dotfiles/.private_envvars
    '';
    shellAliases = {
      # lsd
      ls = "lsd --long --group-dirs=first --date '+%Y-%m-%d %H:%M'";
      lsa = "lsd --long --group-dirs=first --almost-all --date '+%Y-%m-%d %H:%M'";
      lst = "lsd --long --group-dirs=first --tree --depth=2 --date '+%Y-%m-%d %H:%M'";

      # podman
      docker = "podman";
      docker-compose = "podman-compose";
      podmansh = "podman run --tty --interactive --entrypoint='/bin/sh'";

      # kubectl
      k = "kubectl";
      kc = "kube_context";
      kn = "kube_namespace";
      kinto = "kube_shell_into_pod";

      # gcloud
      gcp = "gcloud_change_project";
      gc = "gcloud";
      
      # others
      "cd.." = "cd ..";
      vim = "nvim";
      cat = "bat";
      grep = "grep --color=auto";
      df = "df -H";
      # free = "free -mt";
      wget = "wget -c";
      userlist = "cut -d: -f1 /etc/passwd";
      cal = "cal -y";
    };

    functions = {
      fish_greeting = ''
        neofetch --cpu_temp on --disable gpu term de wm kernel packages distro shell resolution cols cpu --memory_percent on --off
      '';
    };

    generateCompletions = true;
  };

  # SSH
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    #extraConfig = ''
    #  UseKeychain yes
    #  IdentityFile ~/.ssh/id_ed25519
    #'';
  };
  programs.gpg.enable = true;
  programs.password-store.enable = true;

  programs.direnv = {
    enable = true;
    # enableFishIntegration = true;  # defaults to true
    silent = false;
    nix-direnv.enable = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      { plugin = nvim-lspconfig; }
      { plugin = telescope-nvim; }
      { plugin = lualine-nvim; }
      # { plugin = lualine-nvim; config = "something something something"; }
      
      # treesitter
      { plugin = (pkgs.vimPlugins.nvim-treesitter.withPlugins( p: [
         p.tree-sitter-nix
         p.tree-sitter-vim
         p.tree-sitter-bash
         p.tree-sitter-python
         p.tree-sitter-lua
         p.tree-sitter-json
         ]));
       }
    ];
    extraLuaConfig = ''
      vim.wo.number = true
    '';
     #  ${builtins.readFile ./nvim/plugin/something.lua}}  this can go insied extraluaconfig
     # or 
     # programs.neovim.extraLuaConfig = lib.fileContents ../my/init.lua;
  };

 # programs.emacs = {
 #   enable = true;
 #   package = pkgs.emacs30;
 # };
  xdg.configFile.emacs.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/emacs";
  # home.file.".config/emacs" = {
  #   source = ./config/emacs;
  # };


  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      # Inserts a blank line between shell prompts
      add_newline = true;
      
      character = {
        success_symbol = "[➜](green)";
        error_symbol = "[➜](red)";
        vicmd_symbol = "[N](bold blue)";
      };

      python.symbol = " ";
      
      # Disable the package module, hiding it from the prompt completely
      package.disabled = true;
      
      # Disabled modules
      aws.disabled = true;
      battery.disabled = true;
      buf.disabled = true;
      gcloud.disabled = true;
      kubernetes = {
        disabled = true;
        style = "#0189f8 bold";
      };
    };
  };


  programs.git = {
    enable = true;
    userEmail = "sauco.navarro@team.wrike.com";
    userName = "sauco";
    extraConfig = {
      fetch = { prune = true; };
    };
  };

  programs.poetry = {
    enable = true;
  };

  programs.k9s = {
    enable = true;
    aliases = { cj = "cronjobs"; };
  };

  xdg.configFile."k9s/skins/" = {
    source = ./config/k9s/skins;
    recursive = true;
  };

  # Need to pull the whole config as a whole, no symlinks until this is fixed: https://github.com/FelixKratz/SketchyBar/issues/553
  # config = pkgs.lib.fileContents ./config/sketchybar/sketchybarrc;
  xdg.configFile.sketchybar.source = ./config/sketchybar;
  }
