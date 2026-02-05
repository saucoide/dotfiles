{config, ...}: {
  programs.swaylock = {
    enable = true;
    settings = {
      # color = "24273a";
      image = ../../../wallpapers/moria.jpg;
      indicator-idle-visible = true;
      show-failed-attempts = true;
      indicator-radius = 400;
      indicator-thickness = 7;
      indicator-caps-lock = true;
      font-size = 12;
      font = "Iosevka";

      # ---------------------------------
      #           Color Palette
      # ---------------------------------
      #   white       = "#ffffff";
      #   mid-gray    = "#69676c";
      #   dark-gray   = "#222222";
      #   semi-black  = "#00000080";
      #   success     = "#F0FFFF"; # Mellon
      #   fail        = "#d50000"; # Balrog
      # ---------------------------------

      # General
      bs-hl-color = "F0FFFF";
      caps-lock-bs-hl-color = "F0FFFF";
      caps-lock-key-hl-color = "F0FFFF";
      key-hl-color = "F0FFFF";
      layout-bg-color = "F0FFFF10";
      layout-border-color = "F0FFFF10";
      layout-text-color = "F0FFFF";
      separator-color = "F0FFFF11";

      # Ring
      ring-color = "00000010"; # Normal state (black semi-transparent)
      ring-clear-color = "F0FFFF"; # Success state (starlight-blue)
      ring-caps-lock-color = "F0FFFF"; # Highlight color
      ring-ver-color = "F0FFFF"; # Highlight color
      ring-wrong-color = "A42821"; # Fail state (balrog-red)

      # Text
      text-color = "EFBF04"; # Normal text (white)
      text-clear-color = "EFBF04"; # Success text (starlight-blue)
      text-caps-lock-color = "EFBF04"; # Highlight color
      text-ver-color = "EFBF04"; # Highlight color
      text-wrong-color = "EFBF04"; # Fail text (balrog-red)

      # Inside of the ring (semi-transparent backdrop for text)
      inside-color = "00000010";
      inside-clear-color = "F0FFFF10";
      inside-caps-lock-color = "00000010";
      inside-ver-color = "00000010";
      inside-wrong-color = "D5000015";

      # Line connecting the ring to the indicator
      line-color = "F0FFFF20";
      line-clear-color = "F0FFFF20";
      line-caps-lock-color = "F0FFFF20";
      line-ver-color = "F0FFFF20";
      line-wrong-color = "F0FFFF20";
    };
  };
}
