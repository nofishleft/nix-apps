{
  lib,
  fetchurl,
  appimageTools
}:
let
  pname = "jammer";
  version = "3.46";

  src = fetchurl {
    url = "https://github.com/jooapa/jammer/releases/download/${version}/jammer-${version}-x86_64.AppImage";
    sha256 = "tqMFSTk/n5+ORYZELk55lH8+R/J75xItD0rlrrFf/+g=";
  };

    # appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [
    pkgs.icu
    pkgs.libxcrypt-legacy
  ];

  # extraInstallCommands = ''
  #   install -m 444 -D ${appimageContents}/jammer.desktop $out/share/applications/jammer.desktop
  #   substituteInPlace $out/share/applications/jammer.desktop \
  #     --replace-fail 'Exec=AppRun' 'Exec=${pname}'
  # '';
}
