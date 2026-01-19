{config, ...}: {
  services.mako = {
    enable = true;
    settings = {
      font = "JetBrainsMono Nerd Font 12";
      text-color = "#e0e5eb";
      background-color = "#282A33";
      default-timeout = 10000;
      border-color = "#5294e2";
      height = 150;
      border-radius = 2;
      border-size = 2;
      max-visible = 3;
    };
  };
}
