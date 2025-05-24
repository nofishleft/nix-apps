{
  alsa-lib,
  dbus,
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "ytermusic";
  version = "3f0eaed";

  src = fetchFromGitHub {
    owner = "ccgauche";
    repo = "ytermusic";
    rev = "3f0eaedc5486cf80939346f97bca6f3417622448";
    sha256 = "vFwbgXezv1G2q+QC0O4cOPqY4kb1b1xo+MaXJGCF0kc=";
  };

  cargoPatches = [
    # Fix compilation with Rust 1.80 (https://github.com/NixOS/nixpkgs/issues/332957)
    ./time-crate.patch
  ];

  useFetchCargoVendor = true;

  cargoHash = "sha256-5KbqX8HU7s5ZLoCVUmZhvrliAl3wXV4/nMEI5tq2piU=";

  doCheck = true;

  cargoBuildType = "release";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    alsa-lib
    dbus
  ];

  meta = {
    description = "TUI based Youtube Music Player that aims to be as fast and simple as possible";
    homepage = "https://github.com/ccgauche/ytermusic";
    license = lib.licenses.asl20;
    mainProgram = "ytermusic";
  };
}
