{
  lib,
  stdenv,
  rpm,
  autoPatchelfHook,
}:
let
  inherit (builtins) fetchurl;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "";
  version = "";

  src = fetchurl {
    url = "https://download-center.epson.com/f/module/55140851-9360-4c69-806c-acd13078b9c4/iscan-bundle-2.30.6.x64.deb.tar.gz";
    sha256 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [
    rpm
    autoPatchelfHook
  ];
  buildInputs = [

  ];

  meta = {
    description = "";
    homepage = "";
    license = lib.licenses.epson;
    # maintainers = with lib.maintainers; [ ];
  };
})
