{
  config,
  pkgs,
  ...
}: {
  # Aerospace / Window Manager
  services.aerospace = {
    enable = true;
    settings = {
      enable-normalization-flatten-containers = false;
      enable-normalization-opposite-orientation-for-nested-containers = false;
      accordion-padding = 0;
      default-root-container-layout = "tiles"; # tiles|accordion
      default-root-container-orientation = "auto";
      on-focused-monitor-changed = []; # do not follow mouse
      automatically-unhide-macos-hidden-apps = true;
      exec.inherit-env-vars = true;
      exec-on-workspace-change = [
        "/bin/bash"
        "-c"
        "/run/current-system/sw/bin/sketchybar --trigger aerospace_workspace_change FOCUSED=$AEROSPACE_FOCUSED_WORKSPACE"
      ];
      gaps = {
        outer.top = [{monitor."built-in" = 6;} 36]; # 6 on the built-in display, 36 default for all else
        outer.bottom = [{monitor."built-in" = 4;} 2];
        outer.left = 4;
        outer.right = 4;
        inner.horizontal = 6;
        inner.vertical = 6;
      };
      mode.main.binding = {
        # Focus
        cmd-up = "focus up";
        cmd-down = "focus down";
        cmd-left = "focus left";
        cmd-right = "focus right";
        cmd-k = "focus up";
        cmd-j = "focus down";
        cmd-h = "focus left";
        cmd-l = "focus right";

        # Workspace
        cmd-backspace = "workspace-back-and-forth";
        cmd-1 = "workspace 1";
        cmd-2 = "workspace 2";
        cmd-3 = "workspace 3";
        cmd-4 = "workspace 4";
        cmd-5 = "workspace 5";
        cmd-6 = "workspace 6";
        cmd-7 = "workspace 7";
        cmd-8 = "workspace 8";
        cmd-9 = "workspace 9";

        # Move Nodes to Workspace
        ctrl-cmd-1 = "move-node-to-workspace 1";
        ctrl-cmd-2 = "move-node-to-workspace 2";
        ctrl-cmd-3 = "move-node-to-workspace 3";
        ctrl-cmd-4 = "move-node-to-workspace 4";
        ctrl-cmd-5 = "move-node-to-workspace 5";
        ctrl-cmd-6 = "move-node-to-workspace 6";
        ctrl-cmd-7 = "move-node-to-workspace 7";
        ctrl-cmd-8 = "move-node-to-workspace 8";
        ctrl-cmd-9 = "move-node-to-workspace 9";

        # Move Nodes to Workspace & Focus
        cmd-shift-1 = "move-node-to-workspace --focus-follows-window 1";
        cmd-shift-2 = "move-node-to-workspace --focus-follows-window 2";
        cmd-shift-3 = "move-node-to-workspace --focus-follows-window 3";
        cmd-shift-4 = "move-node-to-workspace --focus-follows-window 4";
        cmd-shift-5 = "move-node-to-workspace --focus-follows-window 5";
        cmd-shift-6 = "move-node-to-workspace --focus-follows-window 6";
        cmd-shift-7 = "move-node-to-workspace --focus-follows-window 7";
        cmd-shift-8 = "move-node-to-workspace --focus-follows-window 8";
        cmd-shift-9 = "move-node-to-workspace --focus-follows-window 9";

        # Move & Manipulate windows
        cmd-shift-up = "move up";
        cmd-shift-down = "move down";
        cmd-shift-left = "move left";
        cmd-shift-right = "move right";

        ctrl-shift-up = "join-with up";
        ctrl-shift-down = "join-with down";
        ctrl-shift-left = "join-with left";
        ctrl-shift-right = "join-with right";

        # Splits
        cmd-shift-h = "split horizontal";
        cmd-shift-v = "split vertical";
        # Resize
        ctrl-cmd-up = "resize smart +75";
        ctrl-cmd-down = "resize smart -75";

        # Layout
        ctrl-cmd-equal = "flatten-workspace-tree";
        cmd-enter = "layout v_accordion v_tiles";
        cmd-m = "layout v_accordion";
        cmd-t = "layout h_tiles";
        cmd-shift-f = "layout floating tiling"; # toggle window floating

        # Other key bindings
        cmd-q = "close --quit-if-last-window";
        # ctrl-alt-t = "exec-and-forget open --new -a wezterm";
        # ctrl-alt-t = "exec-and-forget open --new -a wezterm --args start --always-new-process --domain unix";
        ctrl-alt-t = "exec-and-forget open --new -a wezterm --args start --always-new-process";
        ctrl-alt-n = "exec-and-forget open --new -a alacritty";
        # TODO - flameshot?
      };
    };
  };
}
