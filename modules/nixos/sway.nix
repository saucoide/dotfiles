{
  config,
  pkgs,
  ...
}: {
  # The actual sway config is in modules/home/sway
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config = {
      common = {
        default = ["gtk"];
        "org.freedesktop.impl.portal.Screencast" = ["wlr"];
        "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
      };
    };
  };

  environment.sessionVariables = {
    NO_AT_BRIDGE = "1";
    NIXOS_OZONE_WL = "1";
    XDG_CURRENT_DESKTOP = "sway";
  };
}
