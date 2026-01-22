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
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Qogir-dark
  '';
  home.packages = with pkgs; [
    qogir-kde # The specific Qt/Kvantum assets for Qogir
    libsForQt5.qtstyleplugin-kvantum # Qt5 engine
    kdePackages.qtstyleplugin-kvantum # Qt6 engine (crucial for modern apps)
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
