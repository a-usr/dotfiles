{ stdenv, fetchFromGitHub, pkgs }:

stdenv.mkDerivation rec {
  pname = "sddm-theme-astronaut";
  version = "1";
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -aR $src $out/share/sddm/themes/sddm-theme-astronaut
  '';
  buildInputs = [ pkgs.qt6.qt5compat pkgs.qt6.qtdeclarative pkgs.qt6.qtsvg];  
  dontWrapQtApps = true;

  src = fetchTree {
    type = "path";
    path = "/home/usr/sddm-astronaut-theme";
  };
}


