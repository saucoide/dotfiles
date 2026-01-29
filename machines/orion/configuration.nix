# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/bluetooth.nix
    ../../modules/nixos/thunar.nix
    ../../modules/nixos/gpg.nix
    ../../modules/nixos/sway.nix
    ../../modules/nixos/greeter.nix
    ../../modules/nixos/steam/steam.nix
    inputs.home-manager.nixosModules.default
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "saucoide" = import ./home.nix;
    };
  };

  programs.nh = {
    enable = true;
    # clean.enable = true;
    # clean.extraArgs = "--keep-since 4d --keep 3";
    # flake = "/home/user/my-nixos-config"; # sets NH_OS_FLAKE variable for you
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.efi.canTouchEfiVariables = true;

  # Plymouth & Silent Boot
  boot = {
    plymouth = {
      enable = true;
      theme = "hexagon";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = ["hexagon"];
        })
      ];
    };
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };

  console = {
    earlySetup = true;
    useXkbConfig = true;
    # Monokai Pro Spectrum
    colors = [
      "222222"
      "fc618d"
      "7bd88f"
      "fce566"
      "5ad4e6"
      "948ae3"
      "5ad4e6"
      "f7f1ff"
      "69676c"
      "fc618d"
      "7bd88f"
      "fce566"
      "5ad4e6"
      "948ae3"
      "5ad4e6"
      "ffffff"
    ];
  };

  boot.resumeDevice = "/dev/sdb3"; # for hibernation - result of swapon -s
  powerManagement.enable = true;
  # services.logind.settings.Login = {
  #   IdleAction="suspend-then-hibernate";
  #   IdleActionSec=1200;
  # }; # TODO probably not needed, handled by swayidle
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=10m
  '';

  services.fstrim.enable = true; # fstrim is like a gc for the SSD

  # internal ssd
  fileSystems."/home/saucoide/storage" = {
    device = "/dev/disk/by-uuid/9a06ab0b-a482-4611-b4f3-04f0afe3aff1";
    fsType = "btrfs";
    options = [
      "defaults"
      "compress=zstd"
      "noatime"
    ];
  };

  # networking
  networking.hostName = "orion";
  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
  };
  networking.firewall = {
    enable = true;
    # allowedTCPPorts = [];
    # allowedUDPPorts = [];
    # allowed* open to the whole world, i dont want that
    # use nixos-firewall-tool for temporarily opening ports as needed
  };
  services.fail2ban = {
    # Ban IP for 24h after 5 failed ssh attempts
    enable = true;
    maxretry = 5;
    bantime = "24h";
  };

  # printers
  services.printing = {
    enable = true;
    drivers = [
      pkgs.brlaser
      # cups-filters
      # cups-browsed
    ];
  };
  # Uncomment to enable printers via the network
  # services.avahi = {
  #   enable = true;
  #   nssmdns4 = true;
  #   openFirewall = true;
  # };

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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  security.polkit.enable = true;
  programs.fish.enable = true;
  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.udisks2.enable = true; # mounting usb drives
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.saucoide = {
    isNormalUser = true;
    description = "saucoide";
    extraGroups = ["networkmanager" "wheel" "lp" "scanner"];
    shell = pkgs.fish;
    packages = with pkgs; [
      prusa-slicer
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
    liberation_ttf
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Basic stuf
    vim
    git
    curl
    wl-clipboard # copy/paste
    nixos-firewall-tool # to temporarily open ports
    usbutils
    powertop
    gparted-full
  ];
  # Fix uv python ssl.SSLCertVerificationError
  environment.etc.certfile = {
    source = "/etc/ssl/certs/ca-bundle.crt";
    target = "ssl/cert.pem";
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
