{ inputs, pkgs, ... }:{

  programs.alacritty = {
    enable = true;
    settings = {
      env = { TERM = "xterm-256color";};
      terminal.shell = {program = "${pkgs.fish}/bin/fish";};
      window = {
        decorations = "buttonless";
        dynamic_padding = false;
        opacity = 1.0;
        title = "alacritty";
        padding = {x = 6; y = 6;};
      };
      scrolling = { history = 10000; };
      font = {
        size = 12.0;
        offset = {x = 0; y = 1;};
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        bold_italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold Italic";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
      };

      colors = {
        draw_bold_text_with_bright_colors = true;
        primary = {
          background = "#2D2A2E";
          foreground = "#FCFCFA";
        };
        normal = {
          black="#403E41";
          blue="#FC9867";
          cyan="#78DEC8";
          green="#A9DC76";
          magenta="#AB9DF2";
          red="#FF6188";
          white="#FCFCFA";
          yellow="#FFD866";
        };
        bright = {
          black="#727072";
          blue="#FC9867";
          cyan="#78DEC8";
          green="#A9DC76";
          magenta="#AB9DF2";
          red="#FF6188";
          white="#FCFCFA";
          yellow="#FFD866";
        };
      };
      keyboard = {
        bindings = [
          {action="Copy"; key="C"; mods="Control|Shift";}
          {action="Copy"; key="Copy"; mods="None";}
          {action="Paste"; key="V"; mods="Control|Shift";}
          {action="Paste"; key="Paste"; mods="None";}
          {action="PasteSelection"; key="Insert"; mods="Shift";}
          {action="ResetFontSize"; key="Key0"; mods="Control";}
          {action="IncreaseFontSize"; key="Equals"; mods="Control";}
          {action="IncreaseFontSize"; key="Plus"; mods="Control";}
          {action="DecreaseFontSize"; key="Minus"; mods="Control";}
          {action="ToggleFullScreen"; key="F11"; mods="None";}
          {action="ClearLogNotice"; key="L"; mods="Control";}
          {chars="\\f"; key="L"; mods="Control";}
          {action="ScrollPageUp"; key="PageUp"; mods="None"; mode="~Alt";}
          {action="ScrollPageDown"; key="PageDown"; mods="None"; mode="~Alt";}
          {action="ScrollToTop"; key="Home"; mods="Shift"; mode="~Alt";}
          {action="ScrollToBottom"; key="End"; mods="Shift"; mode="~Alt";}
        ];
      };
    };
  };
}
