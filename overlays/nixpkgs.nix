{ inputs, ... }:
let
  master_overlay = final: prev: {
    hyprlock = inputs.hyprlock.packages."${final.stdenv.hostPlatform.system}".hyprlock;
  };

  nixpkgsoverlay =
    final: prev:
    let
      getPkgs = input: input.packages."${final.stdenv.hostPlatform.system}";
      masterPkgs = import inputs.trunk {
        system = final.stdenv.hostPlatform.system;
        config = final.config;
        overlays = [ master_overlay ];
      };
    in
    {
      master = masterPkgs;
      hyprland = (getPkgs inputs.hyprland).default;
      stash = (getPkgs inputs.stash).default;
    };
in
[
  nixpkgsoverlay
]
