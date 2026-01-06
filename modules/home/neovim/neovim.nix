{
  inputs,
  pkgs,
  ...
}: {
  xdg.configFile."nvim" = {
    source = ./nvim;
    recursive = true;
  };
  programs.neovim = {
    enable = true;
  };
}
