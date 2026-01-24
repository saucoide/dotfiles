{
  config,
  lib,
  ...
}: {
  services.kanshi = lib.mkIf config.custom-options.laptop {
    enable = true;
    systemdTarget = "sway-session.target";

    settings = [
      # 1. Home Office
      {
        profile.name = "home";
        profile.outputs = [
          {
            criteria = "LG Electronics LG HDR WFHD 0x0004BB6F";
            position = "0,0";
            mode = "2560x1080";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      }
      # 2. Standalone Laptop
      {
        profile.name = "laptop";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
          }
        ];
      }
    ];
  };
}
