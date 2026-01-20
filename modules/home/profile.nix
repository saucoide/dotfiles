{
  lib,
  config,
  ...
}: {
  options.profiles.laptop = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enable laptop specific stuff";
  };
}
