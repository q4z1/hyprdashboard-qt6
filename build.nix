{ stdenv
, qtbase
, full
, cmake
, ninja
, wrapQtAppsHook
}:
stdenv.mkDerivation {
  pname = "hyprdash";
  version = "1.0";

  # The QtQuick project we created with Qt Creator's project wizard is here
  src = ./hyprdashboard-qt6;

  buildInputs = [
    qtbase
    full
  ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  # If the CMakeLists.txt has an install step, this installPhase is not needed.
  # The Qt default project however does not have one.
  installPhase = ''
    mkdir -p $out/bin
    cp hyprdash $out/bin/
  '';
}