{
  config,
  pkgs,
  ...
}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command =
          "${pkgs.tuigreet}/bin/tuigreet "
          + "--time "
          + "--time-format '%Y-%m-%d %H:%M' "
          + "--remember "
          + "--remember-user-session "
          + "--user-menu "
          + "--asterisks "
          + "--container-padding 2 "
          + "--theme 'border=magenta;text=white;prompt=green;time=gray;action=magenta;button=yellow;container=black;input=cyan' "
          + "--cmd sway";
        user = "greeter";
      };
    };
  };
}
