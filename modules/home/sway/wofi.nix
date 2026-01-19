{config, ...}: {
  programs.wofi = {
    enable = true;
    settings = {
      show = "drun";
      width = "30%";
      lines = 10;
      location = "center";
      prompt = "Search Apps...";
      no_actions = true;
      allow_markup = true;
      insensitivy = true;
      allow_images = true;
      image_size = 24;
      gtk_dark = true;
    };
    style = ''
      window {
        margin: 0px;
        border: 2px solid #5294e2;
        background-color: #282A33;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 16px;
      }

      #input {
        margin: 5px;
        border: none;
        color: #e0e5eb;
        background-color: #32343D;
        outline: none;
      }

      #outer-box { padding: 15px; }
      #inner-box { margin: 5px; }
      #scroll { margin: -2px 0px; }
      #img { margin-right: 15px; }
      #entry:selected {
        background-color: #5294e2;
        border-radius: 2px;
        outline: none;
      }
      #text { color: #e0e5eb; }
      #text:selected { color: #e0e5eb; }
    '';
  };
}