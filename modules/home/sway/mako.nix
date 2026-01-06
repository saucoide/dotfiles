{config, ...}: {
  services.mako = {
    enable = true;
    settings = {
      font = "JetBrainsMono Nerd Font 12";
      text-color = "#d8dee9";
      background-color = "#2e3440";
      default-timeout = 10000;
      border-color = "#81a1c1";
      height = 150;
      border-radius = 2;
      border-size = 2;
      max-visible = 3;
    };
  };
}
