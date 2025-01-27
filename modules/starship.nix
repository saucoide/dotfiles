{
  inputs,
  pkgs,
  ...
}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      # Inserts a blank line between shell prompts
      add_newline = true;

      character = {
        success_symbol = "[➜](green)";
        error_symbol = "[➜](red)";
        vicmd_symbol = "[N](bold blue)";
      };

      directory.style = "bold blue";

      python.symbol = " ";
      nix.format = "via [$symbol]";

      kubernetes = {
        disabled = false;
        style = "#5795e6 bold";
      };

      # Disable the package module, hiding it from the prompt completely
      package.disabled = true;

      # Disabled modules
      aws.disabled = true;
      battery.disabled = true;
      buf.disabled = true;
      gcloud.disabled = true;
    };
  };
}
