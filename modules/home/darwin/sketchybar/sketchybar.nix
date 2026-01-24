{
  inputs,
  pkgs,
  ...
}: {
  xdg.configFile."sketchybar/sketchybarrc".source = ./sketchybarrc;
  xdg.configFile."sketchybar/plugins".source = ./plugins;
}
