{ config, pkgs, ... }: {
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";

  home.username = "saucoide";
  home.homeDirectory = "/home/saucoide";

  home.sessionVariables = {
    FOO = "Hello";
    EDITOR = "nvim";
  };

  imports = [
   configs/hyprland.nix
   configs/waybar.nix
  ];

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
    functions = {
      fish_greeting = "neofetch --cpu_temp on --disable gpu term de wm kernel packages model distro shell resolution cols cpu --memory_percent on --off";
    };
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
    # waybar                # top bar
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
