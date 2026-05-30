{
  inputs,
  pkgs,
  ...
}:
{
  xdg.configFile."nvim" = {
    source = ./nvim;
    recursive = true;
  };
  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
  };
  home.packages = [
    pkgs.tree-sitter
  ];
}
