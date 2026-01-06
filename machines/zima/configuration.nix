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
    inputs.home-manager.nixosModules.default
  ];

  # Nix stuff
  nix.settings = {
    experimental-features = ["flakes" "nix-command"];
    auto-optimise-store = true;
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };
  nixpkgs.config.allowUnfree = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  console = {
    earlySetup = true;
    useXkbConfig = true;
    # Nord
    colors = [
      "2e3440"
      "bf616a"
      "a3be8c"
      "ebcb8b"
      "81a1c1"
      "b48ead"
      "88c0d0"
      "e5e9f0"
      "4c566a"
      "bf616a"
      "a3be8c"
      "ebcb8b"
      "81a1c1"
      "b48ead"
      "8fbcbb"
      "eceff4"
    ];
  };

  # sleep, closig lid, power management, etc
  boot.resumeDevice = "/dev/nvme0n1p3"; # for hibernation - result of swapon -s
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend-then-hibernate";
    HandleLidSwitchDocked = "ignore";
  };
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=10m
  '';
  powerManagement.enable = true;
  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_SCALING_GOVERNOR_ON_SAV = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      CPU_ENERGY_PERF_POLICY_ON_SAV = "power";

      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "balanced";
      PLATFORM_PROFILE_ON_SAV = "low-power";
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80; # to force to 100% once `sudo tlp fullcharge`
      USB_AUTOSUSPEND = 1;
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
    };
  };

  systemd.services.tlp-auto-saver = {
    description = "Trigger TLP SAV mode on low battery";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "tlp-check" ''
        LEVEL=$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/BAT0/capacity)
        STATUS=$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/BAT0/status)
        GOV=$(${pkgs.coreutils}/bin/cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)

        if [ "$LEVEL" -lt 20 ] && [ "$STATUS" = "Discharging" ]; then
          if [ "$GOV" != "powersave" ]; then
            ${pkgs.tlp}/bin/tlp power-saver
          fi
        elif [ "$GOV" = "powersave" ]; then
          ${pkgs.tlp}/bin/tlp start
        fi
      '';
    };
  };

  systemd.timers.tlp-auto-saver = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "2min";
    };
  };

  services.undervolt = {
    enable = true;
    coreOffset = -100;
  };
  services.upower.enable = true; # for tray applets
  services.fstrim.enable = true; # fstrim is like a gc for the SSD

  # networking
  networking.hostName = "zima";
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
  # TODO - this laptop's fingerpritn is not supported in fprintd, there are
  # workarounds https://github.com/viktor-grunwaldt/t480-fingerprint-nixos/blob/main/SETUP.md
  # but leaving it disabled for now
  # services.fprintd = {
  #   # fingerprint scanner
  #   enable = true;
  #   tod = {
  #     enable = true;
  #     driver = pkgs.
  #   };
  # };
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.saucoide = {
    isNormalUser = true;
    description = "saucoide";
    extraGroups = ["networkmanager" "wheel" "lp" "scanner"];
    shell = pkgs.fish;
    packages = with pkgs; [];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "saucoide" = import ./home.nix;
    };
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
    nixos-firewall-tool # temporarily open ports
    usbutils
    powertop
  ];

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
