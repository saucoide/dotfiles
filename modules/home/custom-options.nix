{
  lib,
  config,
  ...
}: {
  options.custom-options = {
    laptop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "enable laptop specific stuff";
    };

    wallpaper = lib.mkOption {
      type = lib.types.either lib.types.path lib.types.str;
      default = ../../wallpapers/cat.jpg;
      description = "Path to default wallpaper";
    };

    wallpaperMode = lib.mkOption {
      type = lib.types.enum [ "fill" "fit" "stretch" "center" "tile" ];
      default = "fill";
      description = "Wallpaper scaling mode";
    };
  };
}
