# Home Manager configuration
{ config, pkgs, lib, ...}: 
let 
  gdk = pkgs.google-cloud-sdk.withExtraComponents(
    [pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin]
  );
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
    # Other packages
    gdk
    pkgs.gcc
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
          {chars="\f"; key="L"; mods="Control";}
          {action="ScrollPageUp"; key="PageUp"; mods="None"; mode="~Alt";}
          {action="ScrollPageDown"; key="PageDown"; mods="None"; mode="~Alt";}
          {action="ScrollToTop"; key="Home"; mods="Shift"; mode="~Alt";}
          {action="ScrollToBottom"; key="End"; mods="Shift"; mode="~Alt";}
        ];
      };
    };
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
  };
  home.file.".config/emacs/early-init.el" = {
    # TODO move this to source from the actual file
    text = ''
      (menu-bar-mode t)
      (tool-bar-mode -1)
      (scroll-bar-mode -1)
      (add-to-list 'default-frame-alist '(undecorated .t))
    '';
  };


  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };


  programs.git = {
    enable = true;
    userEmail = "sauco.navarro@team.wrike.com";
    userName = "sauco";
    extraConfig = {
      fetch = { prune = true; };
    };
  };

  # SKETCHYBAR PLUGINS
  home.file.".config/sketchybar/plugins/aerospace.sh" = {
    text = ''
        #!/usr/bin/env bash
        
        if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
            sketchybar --set $NAME background.drawing=on
        else
            sketchybar --set $NAME background.drawing=off
        fi
    '';
    executable = true;
  };
  home.file.".config/sketchybar/plugins/front_app.sh" = {
    text = ''
        #!/bin/sh
        
        if [ "$SENDER" = "front_app_switched" ]; then
            sketchybar --set $NAME label="$INFO"
        fi
    '';
    executable = true;
  };
}
