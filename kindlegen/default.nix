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
    hash = "sha256-mCjbWiyJcNSHraLKqRo7ZAMhDV0YOn44SbGyBv8EIpY=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ls $src
    install -m755 $src/kindlegen $out/bin
    
    
    runHook postInstall
  '';
}
