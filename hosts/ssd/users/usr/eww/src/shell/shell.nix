{ pkgs ? import <nixpkgs> {}, ... }:
pkgs.mkShell {
  nativeBuildInputs  = [
    pkgs.gobject-introspection
  ];
  buildInputs = with pkgs; [
    python3
    (pkgs.python3.withPackages (py-pkgs: with py-pkgs; [
      pygobject3
      gst-python
      wand
      dbus-python
      requests
    ]))

    imagemagick 
    playerctl
    gtk3
  ];
}