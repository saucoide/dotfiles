{
  inputs,
  pkgs,
  ...
}: let
  # Generate the .dat file from nuggets.txt
  fortuneData = pkgs.stdenv.mkDerivation {
    name = "fortune-nuggets";
    src = ./.;
    buildInputs = [pkgs.fortune];
    buildPhase = ''
      ${pkgs.fortune}/bin/strfile nuggets nuggets.dat
    '';
    installPhase = ''
      mkdir -p $out
      cp nuggets.dat nuggets $out/
    '';
  };
in {
  home.packages = [
    pkgs.fortune
    pkgs.boxes
  ];

  # link files to~/.config/fortune/
  xdg.configFile."fortune/nuggets.dat".source = "${fortuneData}/nuggets.dat";
  xdg.configFile."fortune/nuggets".source = "${fortuneData}/nuggets";
  # home.file.".config/fortune/nuggets.txt".source = "${fortuneData}/nuggets.txt";
  # home.file.".config/fortune/nuggets.dat".source =
}
