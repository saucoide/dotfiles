{
  inputs,
  pkgs,
  ...
}: {
  # Kuberentes tools
  programs.k9s = {
    enable = true;
    # aliases = { cj = "cronjobs"; };
  };

  xdg.configFile."k9s/skins/" = {
    source = ./k9s/skins;
    recursive = true;
  };
}
