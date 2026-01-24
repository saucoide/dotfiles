{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  gdk = pkgs.google-cloud-sdk.withExtraComponents [pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin];
in {
  options = {
    kubernetes.gcp.enable = lib.mkEnableOption "enable google cloud tools";
  };

  config = {
    home.packages =
      [
        pkgs.kubectl
      ]
      ++ lib.optionals config.kubernetes.gcp.enable [
        gdk
      ];

    programs.k9s = {
      enable = true;
      # aliases = { cj = "cronjobs"; };
    };
  };

  # xdg.configFile."k9s/skins/" = {
  #   source = ./k9s/skins;
  #   recursive = true;
  # };
}
