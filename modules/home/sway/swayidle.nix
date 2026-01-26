{
  config,
  pkgs,
  ...
}: {
  services.swayidle = {
    enable = true;
    systemdTarget = "sway-session.target";
    timeouts = [
      {
        timeout = 600;
        command = "${pkgs.sway}/bin/swaymsg \"output * dpms off\"";
        resumeCommand = "${pkgs.sway}/bin/swaymsg \"output * dpms on\"";
      }
      {
        timeout = 900;
        command = "${pkgs.swaylock}/bin/swaylock --daemonize";
      }
      {
        timeout = 1200;
        command = "systemctl suspend-then-hibernate";
      }
    ];
    events = {
      before-sleep = "${pkgs.swaylock}/bin/swaylock --daemonize";
      lock = "${pkgs.swaylock}/bin/swaylock --daemonize";
    };
  };
}
