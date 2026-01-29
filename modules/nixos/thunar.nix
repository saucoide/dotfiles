{
  inputs,
  pkgs,
  ...
}: {
  programs.thunar = {
    enable = true;
    plugins = [
      pkgs.thunar-archive-plugin
      pkgs.thunar-volman
      # pkgs.dropbox-plugin
    ];
  };
  environment.systemPackages = [
    pkgs.file-roller # needed for the thunar archive plugin
  ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
}
