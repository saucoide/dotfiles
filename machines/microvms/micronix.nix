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
    mem = 2024; # 2GB RAM
    vcpu = 2;
    optimize.enable = true;

    # darwin pkgs for the runner (vfkit binary)
    vmHostPackages = hostPkgs;

    # preStart = ''
    #   touch IWASHERE.BELIEVE
    # '';

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
      {
        tag = "agent-config";
        source = "/Users/sauco.navarro/.pi";
        mountPoint = "/home/saucoide/.pi";
        proto = "virtiofs";
      }
      {
        tag = "env";
        source = "/tmp/microvm-env";
        mountPoint = "/run/host-env";
        proto = "virtiofs";
      }
    ];

    # not supported by vfkit
    # credentialFiles = {
    #   TEST_THINGIE = "/home/sauco.navarro/test.py";
    # };

    # Let vfkit use its default NAT networking
    interfaces = [
      {
        type = "user";
        id = "eth0";
        mac = "02:00:00:00:00:01";
      }
    ];
    # forwardPorts = [
    #   {
    #     from = "host"; # or guest
    #     host.port = 8080;
    #     guest.port = 8080;
    #   }
    # ];
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

  environment.variables.TERM = "xterm-256color";
  environment.variables.COLORTERM = "truecolor";
  programs.fish = {
    enable = true;
    vendor = {
      completions.enable = true;
      config.enable = true;
      functions.enable = true;
    };
    interactiveShellInit = ''
      # source host environment variables
      set -l env_file /run/host-env/env.fish
      if test -f $env_file
        source $env_file
        rm -f $env_file
      end

      # uv: store venvs separately from the host
      set -gx UV_CACHE_DIR $HOME/.cache/uv-linux
      set -gx UV_PROJECT_ENVIRONMENT $HOME/.venv-linux

      # cd into workspace on login
      if test -d $HOME/workspace
        cd $HOME/workspace
      end

      # launch pi if MICRONIX_LAUNCH_PI is set
      if set -q MICRONIX_LAUNCH_PI
        set -e MICRONIX_LAUNCH_PI
        pi
      end
    '';
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

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

    tmux
    uv
    just
    python3
    nodejs
    unstable.pi-coding-agent

    # claude-code
    # opencode
    openscad
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
