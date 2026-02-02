{ pkgs, ... }:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in
{
  nix = {
    channel.enable = false;
    optimise.automatic = true;
    settings = {
      experimental-features = "nix-command flakes";
      # substituters = [
      #   "https://cache.nixos.org/"
      #   "https://nix-community.cachix.org/"
      # ];
      # trusted-substituters = [
      #   "https://cache.nixos.org/"
      #   "https://nix-community.cachix.org/"
      # ];
      # trusted-public-keys = [
      #   "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      #   "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # ];
      # trusted-users = [ "saucoide" ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 15d";
    }
    // (
      if isDarwin then
        {
          interval = {
            Hour = 10;
          };
        }
      else
        { dates = "daily"; }
    );
  };

  nixpkgs.config.allowUnfree = true;
}
