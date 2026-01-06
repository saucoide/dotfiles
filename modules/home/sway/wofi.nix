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
        border: 2px solid #5e81ac;
        background-color: #2e3440;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 16px;
      }

      #input {
        margin: 5px;
        border: none;
        color: #eceff4;
        background-color: #3b4252;
      }

      #outer-box { padding: 15px; }
      #inner-box { margin: 5px; }
      #img { margin-right: 15px; }
      #entry:selected {
        background-color: #5e81ac;
        border-radius: 2px;
      }
      #text { color: #eceff4; }
      #text:selected { color: #eceff4; }
    '';
  };
}
