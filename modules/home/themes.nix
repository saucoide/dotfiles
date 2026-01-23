{pkgs, ...}: {
  # GTK programs
  gtk = {
    enable = true;
    theme = {
      name = "Qogir-Dark";
      package = pkgs.qogir-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "Noto Sans";
      size = 11;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # Qt programs
  # QT_* variables set in sway.nix at the nixos module level
  #  otherwise they are not picked up by sway
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Qogir-dark
  '';
  home.packages = with pkgs; [
    qogir-kde # Qt/Kvantum assets for Qogir
    libsForQt5.qtstyleplugin-kvantum # Qt5 engine
    kdePackages.qtstyleplugin-kvantum # Qt6 engine 
  ];

  # Cursor
  home.pointerCursor = {
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
