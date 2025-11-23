{
  stdenv,
  fetchurl,
  autoPatchelfHook
}:
stdenv.mkDerivation {
  pname = "kindlegen";
  version = "2.9";
  
  src = fetchurl {
    url = "https://archive.org/download/kindlegen2.9/kindlegen_linux_2.6_i386_v2_9.tar.gz";
    hash = "sha256-u92xoQEFgcnmIsddhv6GZ149yt9F37I9eNn9Ne/xy8U=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall

    mkdir =p $out/bin
    install -m755 -D $src/kindlegen $out/bin/kindlegen
    
    
    runHook postInstall
  '';
}
