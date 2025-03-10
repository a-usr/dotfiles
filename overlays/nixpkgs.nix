{ inputs, ... }:
let
  nixpkgsoverlay =
    final: prev:
    let
      masterPkgs = import inputs.trunk {
        system = final.system;
        config = final.config;
        overlays = [ master_overlay ];
      };
    in
    {
      master = masterPkgs;
      hyprland = inputs.hyprland.packages."${final.system}".default;
    };

  master_overlay = final: prev: {
    hyprlock = inputs.hyprlock.packages."${final.system}".hyprlock;
  };

in
{
  nixpkgs.overlays = [
    nixpkgsoverlay
    (import (
      builtins.fetchTarball {
        url = "https://github.com/nix-community/emacs-overlay/archive/bb242817e911f6.tar.gz";
        sha256 = "0n10fx7d85pjv9gs5c8681vqglsl3sjn4jqdzk5yci4qzcgjq7kd";
      }
    ))
  ];
}
