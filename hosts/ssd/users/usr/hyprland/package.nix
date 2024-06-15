{ lib
, stdenv
, fetchFromGitHub
, callPackage
, pkg-config
, makeWrapper
, meson
, cmake
, ninja
, binutils
, cairo
, epoll-shim
, git
, hyprcursor
, hyprland-protocols
, hyprlang
, jq
, libGL
, libdrm
, libexecinfo
, libinput
, libuuid
, libxkbcommon
, mesa
, pango
, pciutils
, pkgconf
, python3
, systemd
, tomlplusplus
, wayland
, wayland-protocols
, wayland-scanner
, xwayland
, hwdata
, seatd
, libdisplay-info
, libliftoff
, xorg
, expat
, pcre2
, libselinux
, libsepol
, debug ? false
, enableXWayland ? true
, legacyRenderer ? false
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
, wrapRuntimeDeps ? true
  # deprecated flags
, nvidiaPatches ? false
, hidpiXWayland ? false
, enableNvidiaPatches ? false
}:
assert lib.assertMsg (!nvidiaPatches) "The option `nvidiaPatches` has been removed.";
assert lib.assertMsg (!enableNvidiaPatches) "The option `enableNvidiaPatches` has been removed.";
assert lib.assertMsg (!hidpiXWayland) "The option `hidpiXWayland` has been removed. Please refer https://wiki.hyprland.org/Configuring/XWayland";

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprland" + lib.optionalString debug "-debug";
  version = "0.41.0-unstable-2024-06-10";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = finalAttrs.pname;
    fetchSubmodules = true;
    rev = "ea2501d4556f84d3de86a4ae2f4b22a474555b9f";
    hash = "sha256-Ifx1ioOkAQ9ssXtkYPQQhjd7+ohb24ikWfhhl2tbabY=";
  };

  postPatch = ''
    # Fix hardcoded paths to /usr installation
    sed -i "s#/usr#$out#" src/render/OpenGL.cpp
  '';

  # used by version.sh
  DATE = "2024-06-10";
  HASH = finalAttrs.src.rev;

  depsBuildBuild = [
    # to find wayland-scanner when cross-compiling
    pkg-config
  ;

  nativeBuildInputs = [
    hwdata
    (callPackage ./hyprwayland-scanner.nix {})
    jq
    makeWrapper
    cmake
    meson # for wlroots
    ninja
    pkg-config
    expat
    pcre2
    libselinux
    wayland-scanner
    python3 # for udis86
  ];

  outputs = [
    "out"
    "man"
    "dev"
  ];

  buildInputs = [
    cairo
    git
    #expat
    hyprcursor
    hyprland-protocols
    hyprlang
    libGL
    libdrm
    libinput
    libuuid
    libxkbcommon
    mesa
    wayland
    wayland-protocols
    pango
    pciutils
    tomlplusplus
    # for subproject wlroots-hyprland
    seatd
    libliftoff
    libdisplay-info
    xorg.xcbutilerrors
    xorg.xcbutilrenderutil
  ]
  ++ lib.optionals stdenv.hostPlatform.isBSD [ epoll-shim ]
  ++ lib.optionals stdenv.hostPlatform.isMusl [ libexecinfo ]
  ++ lib.optionals enableXWayland [
    xorg.libxcb
    xorg.libXdmcp
    xorg.xcbutil
    xorg.xcbutilwm
    xwayland
  ]
  ++ lib.optionals withSystemd [ systemd ];

  cmakeBuildType =
    if debug
    then "Debug"
    else "RelWithDebInfo";


  cmakeFlags = [
    (lib.cmakeBool "NO_XWAYLAND" (!enableXWayland))
    (lib.cmakeBool "LEGACY_RENDERER" legacyRenderer)
    (lib.cmakeBool "NO_SYSTEMD" (!withSystemd))
  ];

  postInstall = ''
    ${lib.optionalString wrapRuntimeDeps ''
      wrapProgram $out/bin/Hyprland \
        --suffix PATH : ${lib.makeBinPath [binutils pciutils pkgconf]}
    ''}
  '';

  passthru.providedSessions = [ "hyprland" ];

  meta = with lib; {
    homepage = "https://github.com/hyprwm/Hyprland";
    description = "Dynamic tiling Wayland compositor that doesn't sacrifice on its looks";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wozeparrot fufexan ];
    mainProgram = "Hyprland";
    platforms = lib.platforms.linux;
  };
})
