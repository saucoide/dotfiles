{ config, pkgs, ... }: {

  # System
  time.timeZone = "Europe/Warsaw";
  # time.timeZone = "Pacific/Auckland";
  system.startup.chime = false;  # no thuuum!
  system.defaults.universalaccess.reduceMotion = true;

  system.defaults.NSGlobalDomain._HIHideMenuBar = true; # Hide menu bar
  system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;  # normal scrolling please
  system.defaults.NSGlobalDomain."com.apple.keyboard.fnState" = true;  # default F keys
  system.defaults.NSGlobalDomain.AppleMetricUnits = 1;  # Metric units
  system.defaults.NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
  

  system.defaults.controlcenter = {
    NowPlaying = false;  # Do not show "now playing"
    FocusModes = false;  # No Focus modes
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
  };
  
  # Keyboard
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
    swapLeftCommandAndLeftAlt = true;
    nonUS.remapTilde = true;
  };

  # Trackpad
  system.defaults.trackpad = {
    Clicking = false;  # disable single tap to click
    TrackpadThreeFingerTapGesture = 0;
    TrackpadThreeFingerDrag = false;
  };

  # Networking
  networking = {
    computerName = "macflop";
    hostName = "macflop";
    localHostName = "macflop";
    knownNetworkServices = [
      "Wi-Fi"
      "Thunderbolt Bridge"
    ];
    dns = ["8.8.8.8"];
  };

  # Sleep
  power.sleep.display = 5;
  power.sleep.computer = 15;

  # Use TouchID for sudo
  security.pam.enableSudoTouchIdAuth = true;

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
      on-focused-monitor-changed = [];  # do not follow mouse
      automatically-unhide-macos-hidden-apps = true;
      exec-on-workspace-change = [
          "/bin/bash"
          "-c"
          "sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
      ];
      gaps = {
        outer.top = 6;
        outer.bottom = 6;
        outer.left = 6;
        outer.right = 6;
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
       cmd-shift-f = "layout floating tiling";  # toggle window floating

       # Other key bindings
       cmd-q = "close --quit-if-last-window";
       ctrl-alt-t = "exec-and-forget open --new -a alacritty";
       # ctrl-alt-n = "exec-and-forget open "; # TODO emacsclient
       # TODO - flameshot?
     };
    };
  };

  services.sketchybar = {
    # NOTE: this depends on plugins which are managed in home.nix
    enable = true;
    config = ''
      PLUGIN_DIR="$CONFIG_DIR/plugins"

      ## Bar Appereance
      sketchybar --bar     \
          height=32        \
          blur_radius=20   \
          position=top     \
          sticky=off       \
          padding_left=5   \
          padding_right=5  \
          color=0xff333333

      # Set Defaults
      sketchybar --default                               \
          icon.font="JetBrainsMono Nerd Font:Bold:12.0"  \
          icon.color=0xffffffff                          \
          label.font="JetBrainsMono Nerd Font:Bold:10.0" \
          label.color=0xffffffff                         \
          padding_left=5                                 \
          padding_right=5                                \
          label.padding_left=5                           \
          label.padding_right=5                          \
          icon.padding_left=5                            \
          icon.padding_right=5                           \

      # Workspace indicators
      for sid in $(aerospace list-workspaces --all)
      do
          sketchybar --add item space.$sid left                 \
              --subscribe space.$sid aerospace_workspace_change \
              --set space.$sid                                  \
              icon=$sid                                         \
              label.padding_left=0                              \
              label.padding_right=0                             \
              background.color=0x44ffffff                       \
              background.corner_radius=12                       \
              background.height=18                              \  
              background.drawing=off                            \  
              label.drawing=off                                 \  
              click_script="aerospace workspace $sid"           \  
              script="$CONFIG_DIR/plugins/aerospace.sh"
      done


      # Other Left-Side Indicators

      sketchybar --add item space_separator left    \
          --set space_separator                     \
          icon=**                                   \
          padding_left=10                           \
          padding_right=10                          \
          label.drawing=off                         \
                                                    \
          --add item front_app left                 \
          --set front_app                           \
          script="$CONFIG_DIR/plugins/front_app.sh" \
          icon.drawing=off                          \
          --subscribe front_app front_app_switched  

      sketchybar --update
  
    '';
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
    interactiveShellInit = ''
      # Get most envvars from .profile (requires oh-my-fish & fenv)
      # fenv source $HOME/.profile   # TODO .profile
      source $HOME/dotfiles/.private_envvars
    '';
    shellAliases = {
      # lsd
      ls = "lsd --long --group-dirs=first --date '+%Y-%n-%d %H:%M'";
      lsa = "lsd --long --group-dirs=first --almost-all --date '+%Y-%n-%d %H:%M'";
      lst = "lsd --long --group-dirs=first --tree --depth=2 --date '+%Y-%n-%d %H:%M'";

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
      free = "free -mt";
      wget = "wget -c";
      userlist = "cut -d: -f1 /etc/passwd";
      cal = "cal -y";
    };
    #functions = '' '';
  };

  # Homebrew (if needed for anything)
  #homebrew = {
  #  enable = true;
  #  taps = [ d12frosted/emacs-plus ];
  # brews = [];
  # casks = [];
  #  extraConfig =''
  #    brew "emacs-plus@30", args:["with-ctags", "with-no-frame-refocus", "with-native-comp" "with-imagemagick" "with-poll"]
  #  '';
  #};

  # environment.systemPackages =
  #  [ pkgs.home-manager
  #    pkgs.git
  #    pkgs.uv
  #   ];
}
