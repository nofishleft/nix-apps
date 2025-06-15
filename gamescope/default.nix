{
  fetchFromGitHub,
  gamescope
}:
gamescope.overrideAttrs (oldAttrs: {
  version = "3.16.4";
  src = fetchFromGitHub {
    owner = "ValveSoftware";
    repo = "gamescope";
    tag = "3.16.4";
    fetchSubmodules = true;
    sha256 = "2AxqvZA1eZaJFKMfRljCIcP0M2nMngw0FQiXsfBW7IA=";
  };
})
