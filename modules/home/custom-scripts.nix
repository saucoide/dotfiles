{
  config,
  pkgs,
  lib,
  ...
}: {
  # TODO future - enable options for each of them instead of "laptop" profile
  home.packages =
    [
      (pkgs.writeScriptBin "logout-menu" (builtins.readFile ../../scripts/logout-menu.sh))
      (pkgs.writeScriptBin "ing" (builtins.readFile ../../scripts/ing.py))
      (pkgs.writeScriptBin "weather" (builtins.readFile ../../scripts/weather.sh))
      (pkgs.writeScriptBin "webcam" (builtins.readFile ../../scripts/webcam.sh))
      # (pkgs.writeShellScriptBin "my-hello" '' echo "Hello, ${config.home.username}!" '')
    ]
    # Laptop-only scripts
    ++ lib.optionals config.custom-options.laptop [
      (pkgs.writeScriptBin "battery-control" (builtins.readFile ../../scripts/battery-control.sh))
      (pkgs.writeScriptBin "touchscreen" (builtins.readFile ../../scripts/toggle-touchscreen.sh))
    ];

  # The xdk desktop entries are for things i want to show up in the rofi menu
  xdg.desktopEntries =
    {
      logout-menu = {
        name = "Exit Menu";
        exec = "logout-menu";
        icon = "system-log-out";
        categories = ["System"];
        settings = {
          Keywords = "shutdown;reboot;restart;hibernate;logout;lock;suspend;";
        };
      };
    }
    # Laptop-only desktop entries
    // lib.optionalAttrs
    config.custom-options.laptop {
      battery-control = {
        name = "Battery Control";
        exec = "battery-control";
        icon = "battery";
        categories = ["System"];
      };
      touchscreen-toggle = {
        name = "Toggle Touchscreen";
        exec = "touchscreen";
        icon = "input-touchscreen";
        settings = {
          Keywords = "touchscreen;devices;";
        };
        categories = ["System"];
      };
    };
}
