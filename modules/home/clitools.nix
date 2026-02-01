{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    # nix cli
    pkgs.nh

    # Basics
    pkgs.bat # cat replacement
    pkgs.fd # find replacement
    pkgs.jq
    pkgs.yq-go # jq like
    pkgs.just # command runner
    pkgs.lsd # ls replacement
    pkgs.procs # ps replacement
    pkgs.ripgrep # grep replacement
    pkgs.trash-cli
    pkgs.htop
    pkgs.bottom
    pkgs.tlrc # man page
    pkgs.xh # curl alternative
    pkgs.hyperfine # benchmarking
    pkgs.duf # disks usage
    pkgs.dust # disk space
    pkgs.rmlint # find duplicates etc
    pkgs.imagemagick # img transformation

    # pkgs.mtr
    pkgs.nmap

    pkgs.podman # containers

    pkgs.presenterm # mardown presentation
    pkgs.magic-wormhole # send/receive
    pkgs.pandoc # doc converter

    # database tools
    # pkgs.sqlite
    # pkgs.litecli
    pkgs.pgcli
    # pkgs.duckdb

    # code formatters
    pkgs.stylua # lua
    pkgs.yamlfmt # yaml
    pkgs.taplo # toml
    pkgs.nixfmt # nix
    pkgs.nodePackages.prettier

    # Video
    pkgs.ffmpeg

    # build
    pkgs.gcc
    pkgs.gnumake
  ];
}
