{
  config,
  pkgs,
  ...
}: {
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
    enableSSHSupport = false;
    settings = {
      default-cache-ttl = 600;
      max-cache-ttl = 7200;
    };
  };
}
