{
  inputs,
  pkgs,
  ...
}: {

  xdg.configFile."wezterm/sessionizer.lua" = {
    source = ./wezterm/sessionizer.lua;
  };
  xdg.configFile."wezterm/wezterm.lua".source = pkgs.substituteAll {
    name = "wezterm.lua";
    src = ./wezterm/wezterm.lua;
    fish = "${pkgs.fish}";  # replace what's @fish@ in the source
  };
  programs.wezterm = {
    enable = true;
  };
}
