{ stdenv, fetchFromGitHub, qtdeclarative, qtsvg, qt5compat, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "sddm-theme-astronaut";
  version = "ae7a4";
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -aR $src $out/share/sddm/themes/sddm-theme-astronaut
  '';
  buildInputs = [ qt5compat qtdeclarative qtsvg];  
  dontWrapQtApps = true;

  src = fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "ae6b7a4ad8d14da1cc3c3b712f1241b75dcfe836";
    sha256 = "sha256-pYhHgDiuyckKV2y325sZ5tuqVYLtKaWofKqsY7kgEpQ=";
    };
  }


