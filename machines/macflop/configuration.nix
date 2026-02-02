{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/darwin/aerospace.nix
    ../../modules/darwin/sketchybar.nix
    ../../modules/darwin/jankyborders.nix
    # ../../modules/darwin/homebrew.nix
    inputs.home-manager.darwinModules.home-manager
  ];

  users.users."sauco.navarro" = {
    name = "sauco.navarro";
    home = "/Users/sauco.navarro";
  };

  nix = {
    # linux-builder = {
    #   enable = true;
    # };
    settings.trusted-users = [ "sauco.navarro" ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users."sauco.navarro" = import ./home.nix;
  };

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    # config.allowUnfree = true;
  };

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
    dns = [ "8.8.8.8" ];
  };

  # Sleep
  power.sleep.display = 15;
  power.sleep.computer = 15;

  # Use TouchID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    # noto-fonts
    # noto-fonts-color-emoji
    # liberation_ttf
  ];

  # FISH
  # TODO unclear if i need this
  programs.fish = {
    enable = true;
    vendor = {
      completions.enable = true;
      config.enable = true;
    };
  };

  # environment.systemPackages =
  #  [ pkgs.home-manager
  #    pkgs.git
  #    pkgs.uv
  #   ];
}
