{
  inputs,
  pkgs,
  ...
}: {
  # Rust development stuff
  home.packages = [
    pkgs.rustup
    # pkgs.rustmft
    # pkgs.rust-analyzer
  ];
}
