{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "teamcity-cli";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "JetBrains";
    repo = "teamcity-cli";
    rev = "v${version}";
    hash = "sha256-NIaEwq+sH5qT/1Lg19P/njzXmD70XlWGvZJg07Wpn8U=";
  };

  vendorHash = "sha256-oRR0f3mIKcLJzfjICwraVJxKJzH9K7Bz/aVbqsxvZUs=";

  subPackages = [ "tc" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "TeamCity CLI by JetBrains";
    homepage = "https://github.com/JetBrains/teamcity-cli";
    license = licenses.asl20;
    maintainers = [];
    mainProgram = "tc";
    platforms = platforms.unix;
  };
}
