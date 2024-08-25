{config, pkgs, ...}: {
  
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      animations.enabled = false;
      misc = {
         "disable_hyprland_logo" = true;
      };
      "$mod" = "SUPER";
      binds.allow_workspace_cycles = true;
      bind = [
        "CONTROL_ALT, t, exec, kitty"
        "$mod, k, killactive"

        # Mode switching
        # TODO
        "$mod, M, fullscreen, 1"
        "$mod, F, togglefloating"
        "$mod SHIFT, F, pin"

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
        "$mod, Backspace, workspace, previous"

        "$mod CTRL, 1, movetoworkspacesilent, 1"
        "$mod CTRL, 2, movetoworkspacesilent, 2"
        "$mod CTRL, 3, movetoworkspacesilent, 3"
        "$mod CTRL, 4, movetoworkspacesilent, 4"
        "$mod CTRL, 5, movetoworkspacesilent, 5"
        "$mod CTRL, 6, movetoworkspacesilent, 6"
        "$mod CTRL, 7, movetoworkspacesilent, 7"
        "$mod CTRL, 8, movetoworkspacesilent, 8"
        "$mod CTRL, 9, movetoworkspacesilent, 9"
        "$mod CTRL, Backspace, movetoworkspacesilent, previous"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, Backspace, movetoworkspace, previous"

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
    extraConfig = ''
        exec-once=bash $HOME/dotfiles/scripts/autostart.sh
    '';
  };
}
