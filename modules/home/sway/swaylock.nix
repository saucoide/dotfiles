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
      bs-hl-color = "f4dbd6";
      caps-lock-bs-hl-color = "f4dbd6";
      caps-lock-key-hl-color = "a6da95";
      inside-color = "24273a";
      inside-clear-color = "24273a";
      inside-caps-lock-color = "24273a";
      inside-ver-color = "24273a";
      inside-wrong-color = "24273a";
      key-hl-color = "a6da95";
      layout-bg-color = "24273a";
      layout-border-color = "24273a";
      layout-text-color = "cad3f5";
      line-color = "363a4f";
      line-clear-color = "363a4f";
      line-caps-lock-color = "363a4f";
      line-ver-color = "363a4f";
      line-wrong-color = "363a4f";
      ring-color = "b7bdf8";
      ring-clear-color = "f4dbd6";
      ring-caps-lock-color = "f5a97f";
      ring-ver-color = "8aadf4";
      ring-wrong-color = "ee99a0";
      separator-color = "363a4f";
      text-color = "cad3f5";
      text-clear-color = "f4dbd6";
      text-caps-lock-color = "f5a97f";
      text-ver-color = "8aadf4";
      text-wrong-color = "ee99a0";
    };
  };
}
