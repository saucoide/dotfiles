{pkgs, ...}: {
  # System
  time.timeZone = "Europe/Warsaw";
  # time.timeZone = "Pacific/Auckland";
  system.primaryUser = "sauco.navarro";
  system.startup.chime = false; # no thuuum!
  system.defaults.universalaccess.reduceMotion = true;

  system.defaults.NSGlobalDomain._HIHideMenuBar = true; # Hide menu bar
  system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false; # normal scrolling please
  system.defaults.NSGlobalDomain."com.apple.keyboard.fnState" = true; # default F keys
  system.defaults.NSGlobalDomain.AppleMetricUnits = 1; # Metric units
  system.defaults.NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;

  environment.variables = {
    LANG = "en_US.UTF-8";
  };

  system.defaults.controlcenter = {
    NowPlaying = false; # Do not show "now playing"
    FocusModes = false; # No Focus modes
  };

  # Dock
  system.defaults.dock = {
    orientation = "left";
    autohide = true;
    expose-group-apps = false;
    launchanim = false;
    mru-spaces = false;
    show-recents = false;
    static-only = true;
    tilesize = 42;
    wvous-bl-corner = 1;
    wvous-br-corner = 1;
    wvous-tl-corner = 1;
    wvous-tr-corner = 1;
  };

  # Keyboard (built-in only?)
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
    # swapLeftCommandAndLeftAlt = true;
    nonUS.remapTilde = true;
  };

  # Trackpad
  system.defaults.trackpad = {
    Clicking = false; # disable single tap to click
    TrackpadThreeFingerTapGesture = 0;
    TrackpadThreeFingerDrag = false;
  };

  # Networking
  networking = {
    computerName = "prgm-snavarro4";
    hostName = "prgm-snavarro4";
    localHostName = "prgm-snavarro4";
    knownNetworkServices = [
      "Wi-Fi"
      "Thunderbolt Bridge"
    ];
    dns = ["8.8.8.8"];
  };

  # Sleep
  power.sleep.display = 15;
  power.sleep.computer = 15;

  # Use TouchID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # Fonts
  # fonts.packages = [pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];}];
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  # Aerospace / Window Manager
  services.aerospace = {
    enable = true;
    settings = {
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
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

  services.sketchybar = {
    # NOTE: this depends on plugins which are managed in home.nix
    enable = true;
    # config = pkgs.lib.fileContents ./config/sketchybar/sketchybarrc;
  };

  services.jankyborders = {
    enable = true;
    active_color = "0xff50fa7b";
    inactive_color = "0xff494d64";
    width = 3.0;
    style = "round";
    blacklist = [];
  };

  # FISH
  programs.fish = {
    enable = true;
    vendor = {
      completions.enable = true;
      config.enable = true;
    };
  };

  # Homebrew (if needed for anything)
  # homebrew = {
    # enable = true;
    # onActivation = {
    #   autoUpdate = true;
    #   cleanup = "uninstall";
    #   upgrade = true;
    # };
    # taps = [ "d12frosted/emacs-plus" ];
    # brews = [""];
    # casks = [];
    # extraConfig = ''
    #   brew "emacs-plus@31", args:["with-ctags", "with-no-frame-refocus", "with-native-comp", "with-imagemagick"]
    # '';
  # };

  # environment.systemPackages =
  #  [ pkgs.home-manager
  #    pkgs.git
  #    pkgs.uv
  #   ];
}
