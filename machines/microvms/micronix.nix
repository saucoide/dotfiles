# micronix - lightweight microvm for coding agents
# Runs isolated with project directory mounted at ~/workspace
# because of how the mounting works, we have to build a new derivation
# everytime, so not adding it to a particular host for now
{
  config,
  pkgs,
  lib,
  hostPkgs,
  ...
}:
{
  # Basic system settings
  system.stateVersion = "25.05";
  networking = {
    hostName = "micronix";
    useDHCP = true;
    # nameservers = [ "8.8.8.8" "1.1.1.1" ];
  };

  # Microvm settings
  microvm = {
    hypervisor = "vfkit";
    mem = 4096; # 4GB RAM
    vcpu = 4;

    # darwin pkgs for the runner (vfkit binary)
    vmHostPackages = hostPkgs;

    # shared dirs with host
    shares = [
      {
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/store";
        proto = "virtiofs";
      }
      {
        tag = "workspace";
        source = "/tmp/microvm-workspace";
        mountPoint = "/home/saucoide/workspace";
        proto = "virtiofs";
      }
    ];

    # Let vfkit use its default NAT networking
    interfaces = [
      {
        type = "user";
        id = "eth0";
        mac = "02:00:00:00:00:01";
      }
    ];
  };

  # User configuration
  users.users.saucoide = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  # Passwordless sudo
  security.sudo.wheelNeedsPassword = false;
  services.getty.autologinUser = "saucoide";
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    dnsutils # dig, nslookup
    mtr
    cacert
    vim
    ripgrep
    fd
    jq
    tree
    htop
    neovim

    gnumake
    gcc
    pkg-config

    python3
    nodejs

    claude-code
    opencode
  ];

  # Nix settings
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [ "saucoide" ];
  };
  nixpkgs.config.allowUnfree = true;
}
