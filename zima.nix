# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "zima"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # Harware
  hardware = {
    # opengl
    opengl.enable = true;
    # bluetooth
    bluetooth.enable = true;
    bluetooth.powerOnBoot = false;
    # bluetooth.settings = {}
  };

  # X 
  services.xserver = {
    enable = true;
    videoDrivers = ["modesetting"];  # others: "intel" (old)  "amdgpu-pro" or "nvidia"

    ## Window Manager / Qtile
    windowManager.qtile = {
      enable = true;
      # configFile = "$HOME/dotfiles/.config/qtile/config.py";
      extraPackages = python3Packages: with python3Packages; [
          pulsectl-asyncio
      ];
    };

    # Keyboard Settings
    layout = "us";
    xkbVariant = "";
  };

  services.libinput = {
    enable = true;
    touchpad.tapping = true;
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.saucoide = {
    isNormalUser = true;
    description = "saucoide";
    extraGroups = [
      "networkmanager"
      "wheel" 
      "disk"
      "power"
      "video"
      "audio"
      "docker"
    ];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System Packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
  ];
  programs.fish.enable = true;

  # Services
# 
#   ## Display Manager / Login Screen
#   services.greetd = {
#     enable = true;
#     settings = {
#       default_session = {
#         command = "${pkgs.greetd.tuigreet}/bin/tuigreet \\
#                       --remember \\
#                       --user-menu \\
#                       --asterisks \\
#                       --time \\
#                       --time-format '%F %R' \\
#                       --window-padding 0 \\
#                       --container-padding 2 \\
#                       --cmd Hyprland";
# 	user = "greeter";
#       };
#     restart = true;
#     };
#   };

    

#   programs.hyprland.enable = true;
#   xdg.portal = {
#     enable = true;
#     extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
#   };

  ## Sound with pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  # hardware.pulseaudio.enable = true;
  # nixpkgs.config.pulseaudio = true;
  
  # Fonts
  # fonts.packages = with pkgs; [
  #   (nerdfonts.override { fonts = ["FiraCode" "DroidSansMono" "JetBrainsMono" ]; })
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11";  # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
