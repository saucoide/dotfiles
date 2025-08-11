{
  inputs,
  pkgs,
  ...
}: {
  xdg.configFile."wezterm/sessionizer.lua" = {
    source = ./wezterm/sessionizer.lua;
  };
  # replace what's @fish@ in the source
  xdg.configFile."wezterm/wezterm.lua".source = pkgs.replaceVars ./wezterm/wezterm.lua {fish = "${pkgs.fish}";};
  programs.wezterm = {
    enable = true;
  };
}
