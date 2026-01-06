{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    (pkgs.writeScriptBin "logout-menu" (builtins.readFile ../../scripts/logout-menu.sh))
    (pkgs.writeScriptBin "ing" (builtins.readFile ../../scripts/ing.py))
    (pkgs.writeScriptBin "battery-control" (builtins.readFile ../../scripts/battery-control.sh))
    (pkgs.writeScriptBin "weather" (builtins.readFile ../../scripts/weather.sh))
    (pkgs.writeScriptBin "webcam" (builtins.readFile ../../scripts/webcam.sh))

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # The xdk desktop entries are for things i want to show up in the wofi menu
  xdg.desktopEntries."logout-menu" = {
    name = "Exit Menu";
    exec = "logout-menu";
    icon = "system-log-out";
    categories = ["System"];
    settings = {
      Keywords = "shutdown;reboot;restart;hibernate;logout;lock;suspend;";
    };
  };

  xdg.desktopEntries."battery-control" = {
    name = "Battery Control";
    exec = "battery-control";
    icon = "battery";
    categories = ["System"];
  };
}
