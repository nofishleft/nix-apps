{
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  writeShellScriptBin,
  libbass,
  stdenv,
  unzip,
  fetchurl,
  lib
}:
let
  pname = "jammer";
  version = "3.46";

  bass_aac = {
    name = "bass_aac";
    h = "c/bass_aac.h";
    version = "2.4.6.1";
    so = {
      i686_linux = "libs/x86/libbass_aac.so";
      x86_64-linux = "libs/x86_64/libbass_aac.so";
      armv7l-linux = "libs/armhf/libbass_aac.so";
      aarch64-linux = "libs/aarch64/libbass_aac.so";
    };
    url = "https://web.archive.org/web/20240926143653/https://www.un4seen.com/files/z/2/bass_aac24-linux.zip";
    hash = "sha256-ex8mCxpynTZCszXE96iMVxQfi441PI1A66hgx1+lYEs=";
  };

  libbass_aac = stdenv.mkDerivation {
    pname = "lib${bass_aac.name}";
    inherit (bass_aac) version;

    src = fetchurl {
      inherit (bass_aac) hash url;
    };

    unpackCmd = ''
      mkdir out
      ${unzip}/bin/unzip $curSrc -d out
    '';

    lpropagatedBuildInputs = [ unzip ];
    dontBuild = true;

    installPhase =
            let
              so =
                if bass_aac.so ? ${stdenv.hostPlatform.system} then
                  bass_aac.so.${stdenv.hostPlatform.system}
                else
                  throw "${bass_aac.name} not packaged for ${stdenv.hostPlatform.system} (yet).";
            in
            ''
              mkdir -p $out/{lib,include}
              install -m644 -t $out/lib/ ${so}
              install -m644 -t $out/include/ ${bass_aac.h}
            '';

    meta = with lib; {
      description = "Shareware audio library";
      homepage = "https://www.un4seen.com/";
      license = licenses.unfreeRedistributable;
      platforms = builtins.attrNames bass_aac.so;
      maintainers = with maintainers; [ poz ];
    };
  };

  jammer = (buildDotnetModule {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "jooapa";
      repo = pname;
      rev = version;
      sha256 = "Ngyq1BWMD9susoady/JZmR0j7VQUO9ycRQ85rGskBzo=";
    };

    projectFile = "Jammer.CLI/Jammer.CLI.csproj";
    buildType = "Release";
    dotnetFlags = [
      "/p:PublishSingleFile=true"
      "-p:UseForms=false"
      "-p:DefineConstants=\"CLI_UI\""
    ];

    executables = ["Jammer.CLI"];

    nugetDeps = ./deps.json;

    dotnet-sdk = dotnetCorePackages.sdk_8_0;
    dotnet-runtime = dotnetCorePackages.runtime_8_0;

    runtimeDeps = [
      libbass
      libbass_aac
    ];
  });
in
(writeShellScriptBin "jammer" "exec -a $0 ${jammer}/bin/Jammer.CLI $@")
