{
  pkgs,
  config,
  ...
}: {
  programs.rofi = {
    enable = true;
    font = "JetBrainsMono Nerd Font 14";
    extraConfig = {
      modi = "drun,window,filebrowser";
      show-icons = true;
      icon-theme = "Papirus-Dark";
      terminal = "wezterm";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "󱓞 drun";
      display-window = "󰲌 window";
      display-filebrowser = " files";
      sidebar-mode = true;
    };

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg = mkLiteral "#282A33";
        bg-light = mkLiteral "#32343D";
        fg = mkLiteral "#e0e5eb";
        fg2 = mkLiteral "#D9E0EE";
        grey = mkLiteral "#737994";
        accent = mkLiteral "#5294e2";
        width = 600;
      };

      "element-text, element-icon , mode-switcher" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      "window" = {
        height = mkLiteral "360px";
        border = mkLiteral "2px";
        border-color = mkLiteral "@accent";
        background-color = mkLiteral "@bg";
      };

      "mainbox" = {
        background-color = mkLiteral "@bg";
        children = map mkLiteral ["inputbar" "listview" "mode-switcher"];
      };

      "inputbar" = {
        children = map mkLiteral ["entry"];
        background-color = mkLiteral "@bg-light";
        border-radius = mkLiteral "3px";
        margin = mkLiteral "10px 10px 5px 10px";
        padding = mkLiteral "2px";
      };

      "prompt" = {
        enabled = false;
      };

      "entry" = {
        padding = mkLiteral "4px 10px";
        text-color = mkLiteral "@fg";
        background-color = mkLiteral "inherit";
        placeholder = "Search...";
        placeholder-color = mkLiteral "@grey";
      };

      "listview" = {
        border = mkLiteral "0px 0px 0px";
        padding = mkLiteral "6px 0px 0px";
        margin = mkLiteral "5px 10px 10px 10px";
        columns = 1;
        lines = 10;
        background-color = mkLiteral "@bg";
      };

      "element" = {
        padding = mkLiteral "5px";
        background-color = mkLiteral "@bg";
        text-color = mkLiteral "@fg";
        border-radius = mkLiteral "3px";
      };

      "element-icon" = {
        size = mkLiteral "24px";
      };

      "element selected" = {
        background-color = mkLiteral "@accent";
        text-color = mkLiteral "@fg2";
      };

      "mode-switcher" = {
        spacing = 0;
        margin = mkLiteral "0px 10px 10px 10px";
      };

      "button" = {
        padding = mkLiteral "5px";
        background-color = mkLiteral "@bg";
        text-color = mkLiteral "@grey";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.5";
      };

      "button selected" = {
        background-color = mkLiteral "@bg-light";
        text-color = mkLiteral "@grey";
      };

      "message" = {
        background-color = mkLiteral "@bg-light";
        margin = mkLiteral "2px";
        padding = mkLiteral "2px";
        border-radius = mkLiteral "5px";
      };

      "textbox" = {
        padding = mkLiteral "6px";
        margin = mkLiteral "10px";
        text-color = mkLiteral "@accent";
        background-color = mkLiteral "@bg-light";
      };
    };
  };
}
