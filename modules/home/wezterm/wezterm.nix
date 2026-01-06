{
  inputs,
  pkgs,
  ...
}: {
  xdg.configFile."wezterm/sessionizer.lua" = {
    source = ./sessionizer.lua;
  };
  # replace what's @fish@ in the source
  xdg.configFile."wezterm/wezterm.lua".source = pkgs.replaceVars ./wezterm.lua {fish = "${pkgs.fish}";};
  programs.wezterm = {
    enable = true;
  };
}
