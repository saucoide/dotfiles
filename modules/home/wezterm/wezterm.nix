{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: {
  options = {
    wezterm.font_size = lib.mkOption {
      type = lib.types.int;
      default = 10;
      description = "wezterm font size";
    };

    wezterm.window_decorations = lib.mkOption {
      type = lib.types.str;
      default = "NONE";
      description = "NONE | TITLE | RESIZE ";
    };
  };

  config = {
    programs.wezterm = {
      enable = true;
    };
    xdg.configFile."wezterm/sessionizer.lua".source = pkgs.replaceVars ./sessionizer.lua {FD = "${pkgs.fd}";};
    xdg.configFile."wezterm/wezterm.lua".source = pkgs.replaceVars ./wezterm.lua {
      FISH = "${pkgs.fish}";
      FONT_SIZE = config.wezterm.font_size;
      WINDOW_DECORATIONS = config.wezterm.window_decorations;
    };
  };
}
