{
  config,
  pkgs,
  ...
}: {
  # Homebrew (if needed for anything)
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
    taps = ["d12frosted/emacs-plus"];
    brews = [""];
    casks = [];
    extraConfig = ''
      brew "emacs-plus@31", args:["with-ctags", "with-no-frame-refocus", "with-native-comp", "with-imagemagick"]
    '';
  };
}
