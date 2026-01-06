{
  config,
  pkgs,
  ...
}: let
  json = text: builtins.fromJSON ''"${text}"'';
in {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 18;
        spacing = 5;
        modules-left = ["sway/workspaces"];
        modules-center = ["sway/window"];
        modules-right = ["temperature" "wireplumber" "battery" "idle_inhibitor" "tray" "clock"];

        "sway/workspaces" = {
          format = "{name}";
          on-click = "activate";
          format-icons = {
            active = json "\\uf444";
            default = json "\\uf4c3";
          };

          icon-size = 10;
          sort-by-number = true;
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
            "6" = [];
            "7" = [];
            "8" = [];
            "9" = [];
          };
        };

        clock = {
          format = "{:%Y-%m-%d %H:%M}";
          format-alt = "{:%H:%M}";
        };

        wireplumber = {
          format = "{icon} {volume}%";
          format-muted = " ";
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          format-icons = ["" "" ""];
          max-volume = 100;
          scroll-step = 5;
          tooltip-format = "Name: {node_name}\nVolume: {volume}%";
        };

        battery = {
          bat = "BAT0";
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}";
          format-charging = "󱐋";
          format-icons = [" " " " " " " " " "];
          tooltip-format = "Capacity: {capacity}%
Power: {power}W
Time: {time}
Health: {health}%
Cycles: {cycles}";
        };

        temperature = {
          critical-threshold = 80;
          warning-threshold = 65;
          format = "{temperatureC}°C";
        };

        # network = {
        #   format = "";
        #   format-ethernet = json "\udb83\udc9d";
        #   format-wifi = "{icon}";
        #   format-disconnected = json "\udb83\udc9c";
        #   format-icons = [(json "\udb82\udd2f") (json "\udb82\udd1f") (json "\udb82\udd22") (json "\udb82\udd25") (json "\udb82\udd28")];
        #   tooltip-format-wifi = "{essid} ({signalStrength}%)";
        #   tooltip-format-ethernet = "{ifname}";
        #   tooltip-format-disconnected = "Disconnected";
        # };

        # bluetooth = {
        #   format = json "\udb80\udcaf";
        #   format-disabled = json "\udb80\udcb2";
        #   format-connected = json "\udb80\udcb1";
        #   tooltip-format = "{controller_alias}\t{controller_address}";
        #   tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
        #   tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
        #   on-click = "${pkgs.blueman}/bin/blueman-manager";
        # };

        tray = {
          icon-size = 16;
          spacing = 16;
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = json "\\udb80\\udd76";
            deactivated = json "\\udb83\\udfaa";
          };
          tooltip-format-activated = "idle-inhibitor: ON";
          tooltip-format-deactivated = "idle-inhibitor: OFF";
        };
      };
    };
    style = ''
      @define-color foreground #eeeeee;
      @define-color foreground-inactive #aaaaaa;
      @define-color background #000000;

      * {
          font-family: "JetBrainsMono Nerd Font", "JetBrainsMono NF";
          font-size: 13px;
          padding: 0;
          margin: 0;
      }

      #waybar {
          color: @foreground;
          background-color: @background;
      }

      #workspaces button {
          color: @foreground;
          margin: 4px 2px;
          padding: 0;
          border-radius: 50%;
          min-width: 20px;
          min-height: 20px;
      }

      #workspaces button.focused {
          color: @background;
          background-color: @foreground;
      }

      #workspaces button.empty {
          color: @foreground-inactive;
      }

      #memory,
      #wireplumber,
      #idle_inhibitor,
      #tray,
      #temperature,
      #clock {
          padding-right: 1em
      }

      #battery {
          padding-right: 1em;
      }

      #battery.charging {
          color: #a6da95;
      }

      #battery.warning {
          color: #f5a97f;
      }

      #battery.critical {
          color: #bf616a;
      }

      #temperature.warning {
          color: #ebcb8b;
      }
      #temperature.critical {
          color: #bf616a;
      }
    '';
  };
}
