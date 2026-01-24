{
  config,
  pkgs,
  ...
}: {
  services.sketchybar = {
    # NOTE: this depends on plugins which are managed in home.nix
    enable = true;
    # config = pkgs.lib.fileContents ./config/sketchybar/sketchybarrc;
  };
}
