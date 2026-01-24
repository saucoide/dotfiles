{
  lib,
  config,
  ...
}: {
  options.custom-options.laptop = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enable laptop specific stuff";
  };
}
