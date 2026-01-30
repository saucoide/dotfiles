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
      font-size = 24;
      font = "Iosevka";

      # ---------------------------------
      #           Color Palette
      # ---------------------------------
      #   white       = "ffffff";
      #   mid-gray    = "69676c";
      #   dark-gray   = "222222";
      #   semi-black  = "00000080";
      #   success     = "F0FFFF"; # Starlight blue
      #   fail        = "A42821 "; # Balrog red
      # ---------------------------------

      # General
      bs-hl-color = "F0FFFF";
      caps-lock-bs-hl-color = "F0FFFF";
      caps-lock-key-hl-color = "F0FFFF";
      key-hl-color = "F0FFFF";
      layout-bg-color = "F0FFFF";
      layout-border-color = "F0FFFF";
      layout-text-color = "F0FFFF";
      separator-color = "F0FFFF";

      # Ring
      ring-color = "00000080"; # Normal state (black semi-transparent)
      ring-clear-color = "F0FFFF"; # Success state (starlight-blue)
      ring-caps-lock-color = "F0FFFF"; # Highlight color
      ring-ver-color = "F0FFFF"; # Highlight color
      ring-wrong-color = "A42821"; # Fail state (balrog-red)

      # Text
      text-color = "F0FFFF"; # Normal text (white)
      text-clear-color = "F0FFFF"; # Success text (starlight-blue)
      text-caps-lock-color = "F0FFFF"; # Highlight color
      text-ver-color = "F0FFFF"; # Highlight color
      text-wrong-color = "A42821"; # Fail text (balrog-red)

      # Inside of the ring (semi-transparent backdrop for text)
      inside-color = "00000060";
      inside-clear-color = "00000060";
      inside-caps-lock-color = "00000060";
      inside-ver-color = "00000060";
      inside-wrong-color = "00000000";

      # Line connecting the ring to the indicator
      line-color = "F0FFFFa6";
      line-clear-color = "F0FFFFa6";
      line-caps-lock-color = "F0FFFFa6";
      line-ver-color = "F0FFFFa6";
      line-wrong-color = "F0FFFFa6";
    };
  };
}
