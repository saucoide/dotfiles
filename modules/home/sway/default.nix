{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./sway.nix
    ./waybar.nix
    ./swaylock.nix
    ./swayidle.nix
    ./kanshi.nix
    ./rofi.nix
    ./mako.nix
  ];

  config = {
    home.packages = with pkgs; [
      (pkgs.writeScriptBin "adaptative-resize" (builtins.readFile ./scripts/adaptative-resize.sh))
      libnotify # to send notifications
      mako # notificatons daemon ( to show them )
      grim # screenshots
      slurp # screenshots region
      wdisplays # one-off display switching
      networkmanagerapplet # nm applet
      swaylock # screen locker
      swayidle # idle daemon
      polkit_gnome # polkit authentication agent
    ];

    services.flameshot = {
      enable = true;
      settings = {
        General = {
          useGrimAdapter = true;
          # Stops warnings for using Grim
          disabledGrimWarning = true;
          savePath = "${config.home.homeDirectory}/screenshots";
          savePathFixed = true;
          disabledTrayIcon = true;
          showStartupLaunchMessage = false;
          saveAsFileExtension = ".png";
        };
      };
    };

    programs.swayimg = {
      enable = true;
      # settings = {};
    };
  };
}
