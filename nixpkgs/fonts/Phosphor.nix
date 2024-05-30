{ stdenvNoCC, fetchurl, unzip, ... }:
stdenvNoCC.mkDerivation rec {
  pname = "Phosphor-Icons";
  version = "1";
  nativeBuildInputs = [ unzip ];
  unpackPhase = ''
    mkdir -p "$out/share/fonts/truetype"
    unzip $src Fonts/* -d "$out/share/fonts/truetype/"
    '';
  installPhase = ''
    find -wholename "$out/share/fonts/truetype/Fonts/*.woff2" -exec rm {} \;
    mv "$out/share/fonts/truetype/Fonts" "$out/share/fonts/truetype/phosphor-icons" 
 '';
  
  src = fetchurl {
    url = "https://github.com/phosphor-icons/homepage/releases/download/v2.1.0/phosphor-icons.zip";
    hash = "sha256-1Nq7Hkxa62ftZ9ncP0fYuefFfP832cNdp1ofwX6qEeo=";
  };
}
