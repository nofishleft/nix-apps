{
  boost,
  cmake,
  fetchFromGitHub,
  libglut,
  freetype,
  glew,
  libdeflate,
  libjpeg,
  libmypaint,
  libpng,
  libusb1,
  lz4,
  xz,
  lzo,
  openblas,
  opencv,
  pkg-config,
  #qt5,
  libsForQt5,
/*
  qtbase,
  qtmultimedia,
  qtscript,
  qtserialport,
  qttools,
  qtwayland,
  wrapQtAppsHook,
*/
  lib,
  stdenv,
  superlu,
  xorg,
  zlib,
}:
let
  tahoma2d-ver = "1.5.1";
  libtiff-ver = "4.2.0";

  src = fetchFromGitHub {
    owner = "tahoma2d";
    repo = "tahoma2d";
    rev = "refs/tags/v${tahoma2d-ver}";
    hash = "sha256-oyXzMRQGghu2Bj66Bc6QVLEqcKOvsZU3LlhsDNjh1uo=";
  };

  tahoma2d-libtiff = stdenv.mkDerivation {
    pname = "libtiff";
    version = "${libtiff-ver}-tahoma2d";

    inherit src;
    outputs = [
      "bin"
      "dev"
      "out"
      "man"
      "doc"
    ];

    nativeBuildInputs = [ pkg-config ];
    propagatedBuildInputs = [
      zlib
      libjpeg
      xz
    ];
    postUnpack = ''
      sourceRoot="$sourceRoot/thirdparty/tiff-${libtiff-ver}"
    '';

    # opentoonz uses internal libtiff headers
    postInstall = ''
      cp libtiff/{tif_config,tif_dir,tiffiop}.h $dev/include
    '';
  };

in stdenv.mkDerivation {
  inherit src;

  pname = "tahoma2d";
  version = tahoma2d-ver;

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.qt5.wrapQtAppsHook
    xorg.libX11.dev
  ];

  buildInputs = [
    tahoma2d-libtiff

    boost
    freetype
    glew
    libdeflate
    libjpeg
    libglut
    libmypaint
    libpng
    libusb1
    lz4
    lzo
    openblas
    opencv
    #qt5
    /*
    qtbase
    qtmultimedia
    qtscript
    qtserialport
    qttools
    qtwayland
    */
    superlu
    xz
    zlib
  ] ++ (with libsForQt5.qt5; [
    qtbase
    qtmultimedia
    qtscript
    qtserialport
    qttools
    qtwayland
  ]);

  postUnpack = "sourceRoot=$sourceRoot/toonz";
  patches = [
    ./fixBuildingWithQt5WhileQt6IsInstalled.patch
    ./changeTurboJpegImportPath.patch
  ];
  patchFlags = "-p2";
  cmakeDir = "../sources";
  cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DTIFF_INCLUDE_DIR=${tahoma2d-libtiff.dev}/include"
    "-DTIFF_LIBRARY=${tahoma2d-libtiff.out}/lib/libtiff.so"
    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
  ];

  postInstall = ''
    sed -i '/cp -r .*stuff/a\    chmod -R u+w $HOME/.config/Tahoma2D/stuff' $out/bin/tahoma2d
  '';

  /*

  dontUseCmakeConfigure=true;

  buildPhase = ''
    # libtiff
    pushd $src/thirdparty/tiff-4.2.0
      ./configure --with-pic --disable-jbig --disable-webp
      make -j$(nproc)
    popd

    # tahoma2d
    mkdir -p $src/toonz/build
    pushd $src/toonz/build
      cmake $src/toonz/sources -DCMAKE_INSTALL_PREFIX=$out/opt/tahoma2d
      make -j$(nproc)
    popd
  '';

  installPhase = ''
    mkdir -p $out
    pushd $src/toonz/build
      make install
    popd

    mkdir -p $out/bin
    ln -sT $out/bin/tahoma2d $out/opt/tahoma2d/bin/tahoma2d
  '';

  postInstall = ''
    mkdir -p $HOME/.config/Tahoma2D
    cp -r $src/stuff $HOME/.config/Tahoma2D/
    sed 's/$HOME/'$out'/' $src/toonz/install/SystemVar.ini > $HOME/.config/Tahoma2D/SystemVar.ini
  '';
  */

}

