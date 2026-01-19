{config, ...}: {
  programs.swaylock = {
    enable = true;
    settings = {
      # color = "24273a";
      image = ../../../wallpapers/yellow-tree-warmer.png;
      indicator-idle-visible = true;
      show-failed-attempts = true;
      indicator-radius = 100;
      indicator-thickness = 15;
      indicator-caps-lock = true;
      font-size = 24;
      bs-hl-color = "e3e1e4";
      caps-lock-bs-hl-color = "e3e1e4";
      caps-lock-key-hl-color = "7bd88f";
      inside-color = "222222";
      inside-clear-color = "222222";
      inside-caps-lock-color = "222222";
      inside-ver-color = "222222";
      inside-wrong-color = "222222";
      key-hl-color = "7bd88f";
      layout-bg-color = "222222";
      layout-border-color = "222222";
      layout-text-color = "f7f1ff";
      line-color = "69676c";
      line-clear-color = "69676c";
      line-caps-lock-color = "69676c";
      line-ver-color = "69676c";
      line-wrong-color = "69676c";
      ring-color = "948ae3";
      ring-clear-color = "e3e1e4";
      ring-caps-lock-color = "fce566";
      ring-ver-color = "5ad4e6";
      ring-wrong-color = "fc618d";
      separator-color = "69676c";
      text-color = "f7f1ff";
      text-clear-color = "e3e1e4";
      text-caps-lock-color = "fce566";
      text-ver-color = "5ad4e6";
      text-wrong-color = "fc618d";
    };
  };
}
