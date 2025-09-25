{
  inputs,
  pkgs,
  ...
}: {
  xdg.configFile."nvim" = {
    source = ./neovim;
    recursive = true;
  };
  programs.neovim = {
    enable = true;
  };
}
