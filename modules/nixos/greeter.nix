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
          + "--theme 'border=blue;text=cyan;prompt=green;time=white;action=blue;button=yellow;container=black;input=blue' "
          + "--cmd sway";
        user = "greeter";
      };
    };
  };
}
