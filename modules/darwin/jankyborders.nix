{
  config,
  pkgs,
  ...
}: {
  services.jankyborders = {
    enable = true;
    active_color = "0xff50fa7b";
    inactive_color = "0xff494d64";
    width = 3.0;
    style = "round";
    blacklist = [];
  };
}
