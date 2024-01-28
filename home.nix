{ config, pkgs, ... }:
{
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";

  home.username = "saucoide";
  home.homeDirectory = "/home/saucoide";

  home.sessionVariables = {
    FOO = "Hello";
    EDITOR = "nvim";
  };
 
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "CONTROL_ALT, t, exec, kitty"
        "$mod, k, killactive"

	# Workspace switching
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 0"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 0"

        # Window selection
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, down, movefocus, d"
        "$mod, up, movefocus, u"

      ];
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "lsd --long --color=always --group-dirs=first --date '+%Y-%m-%d %H:%M'";
      lsa = "lsd --long --almost-all --color=always --group-dirs=first --date '+%Y-%m-%d %H:%M'";
      lst = "lsd --long --tree --depth=2 --color=always --date '+%Y-%m-%d %H:%M'";
    };
    functions = {
      fish_user_key_bindings = "fish_vi_key_bindings" ;
      testf = "echo hello $argv";
    }; 
    interactiveShellInit = "neofetch";
     
  };
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = true;
    };
  };
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    settings = {
      confirm_os_window_close = 0;
    };
    theme = "Flatland";
    font.name = "JetBrainsMono";
  };


  home.packages = with pkgs; [
    # Desktop
    waybar                # top bar
    swww                  # wallpaper

    # Notifications
    dunst
    libnotify

    # Terminal
    kitty

    # CLI Tools
    neovim
    lsd                    # A better ls
    htop
    wl-clipboard           # pbcopy/pbpaste
    trashy                 # A better trash-cli
    neofetch
    

    # Launcher
    rofi-wayland

    # GUI Applications
    xfce.thunar
  ];

}
