{
  description = "Misc apps";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:

    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        packages = {
          tahoma2d = pkgs.callPackage ./tahoma2d {};
          jammer = pkgs.callPackage ./jammer {};
          jammer-appimage = pkgs.callPackage ./jammer_appimage {};
          ytermusic = pkgs.callPackage ./ytermusic {};
          gamescope = pkgs.callPackage ./gamescope {};
        };
      }
    );
}
