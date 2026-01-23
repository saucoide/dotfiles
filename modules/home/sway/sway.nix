{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      startup = [
        {command = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY SWAYSOCK DISPLAY XDG_CURRENT_DESKTOP NO_AT_BRIDGE NIXOS_OZONE_WL PATH QT_QPA_PLATFORMTHEME QT_STYLE_OVERRIDE";}
        {
          command = "systemctl --user restart waybar";
          always = true;
        }
        {command = "nm-applet --indicator";}
        {command = "blueman-applet";}
        {command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";}
        {command = "touchscreen disabled";}
      ];
      modifier = "Mod4";
      menu = "rofi -show drun";
      keybindings = let
        cfg = config.wayland.windowManager.sway;
        mod = cfg.config.modifier;
      in {
        # ???
        "Ctrl+Alt+t" = "exec ${cfg.config.terminal}";
        "${mod}+q" = "kill";
        "${mod}+r" = "exec ${cfg.config.menu}";
        "${mod}+e" = "exec thunar";
        "${mod}+Space" = "exec ${cfg.config.menu}";
        "${mod}+Shift+l" = "exec swaylock --daemonize";

        # Focus
        "${mod}+Up" = "focus up";
        "${mod}+Down" = "focus down";
        "${mod}+Left" = "focus left";
        "${mod}+Right" = "focus right";
        "${mod}+k" = "focus up";
        "${mod}+j" = "focus down";
        "${mod}+h" = "focus left";
        "${mod}+l" = "focus right";

        # Splits
        "${mod}+Shift+h" = "splith";
        "${mod}+Shift+v" = "splitv";

        # Workspaces
        # Switch to another workspace
        "${mod}+BackSpace" = "workspace back_and_forth";
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";

        # Move Nodes
        # Moves container to workspace but stays on current workspace
        "Ctrl+${mod}+1" = "move container to workspace number 1";
        "Ctrl+${mod}+2" = "move container to workspace number 2";
        "Ctrl+${mod}+3" = "move container to workspace number 3";
        "Ctrl+${mod}+4" = "move container to workspace number 4";
        "Ctrl+${mod}+5" = "move container to workspace number 5";
        "Ctrl+${mod}+6" = "move container to workspace number 6";
        "Ctrl+${mod}+7" = "move container to workspace number 7";
        "Ctrl+${mod}+8" = "move container to workspace number 8";
        "Ctrl+${mod}+9" = "move container to workspace number 9";

        # Move Nodes & Switch
        # Moves container and switches to that workspace
        "${mod}+Shift+1" = "move container to workspace number 1; workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2; workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3; workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4; workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5; workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6; workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7; workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8; workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9; workspace number 9";

        # Move Windows
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Right" = "move right";

        # Resize
        "Ctrl+${mod}+Up" = "exec adaptative-resize grow 75px";
        "Ctrl+${mod}+Down" = "exec adaptative-resize shrink 75px";

        # Layouts
        "${mod}+m" = "fullscreen toggle";
        "${mod}+t" = "layout toggle split";

        "${mod}+Return" = "layout toggle splitv stacking";
        "${mod}+Shift+f" = "floating toggle";
        # reset layout
        "Ctrl+${mod}+equal" = "[workspace=__focused__] floating enable; [workspace=__focused__] floating disable; layout splith";

        # Audio
        "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

        # brithgness
        "XF86MonBrightnessup" = "exec brightnessctl set 5%+";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";

        # Screenshots
        # "Print" = "exec grim -g \"$(slurp)\" ~/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png";
        "Print" = "exec flameshot gui";
      };
      # terminal = "wezterm";
      terminal = "wezterm-gui start --always-new-process";
      output = {
        "*" = {
          bg = "${../../../wallpapers/landscape-bird-gray.jpg} fill";
        };
      };
      bars = [];
      floating = {
        criteria = [
          {
            app_id = "thunar";
            title = "^Rename .*";
          }
        ];
      };
      window = {
        border = 2;
        titlebar = false;
      };
      gaps = {
        bottom = 0;
        top = 0;
        left = 0;
        right = 0;
        horizontal = 0;
        inner = 2;
        outer = 2;
        smartGaps = true;
        smartBorders = "on";
      };
      colors = {
        background = "#222222"; # Dark background for gaps
        focused = {
          background = "#282828";
          border = "#7bd88f"; # Spectrum green
          childBorder = "#7bd88f";
          indicator = "#948ae3"; # where next split will happen
          text = "#ffffff";
        };
        focusedInactive = {
          background = "#282828";
          border = "#323232"; # Subtle gray
          childBorder = "#323232";
          indicator = "#323232";
          text = "#888888";
        };
        unfocused = {
          background = "#282828";
          border = "#1e1e1e"; # Darker, nearly invisible gray
          childBorder = "#1e1e1e";
          indicator = "#1e1e1e";
          text = "#888888";
        };
        urgent = {
          background = "#282828";
          border = "#fc618d"; # Spectrum red for alerts
          childBorder = "#fc618d";
          indicator = "#fc618d";
          text = "#ffffff";
        };
      };
    };
  };
}
