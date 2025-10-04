{ inputs, ... }:
let
  master_overlay = final: prev: {
    hyprlock = inputs.hyprlock.packages."${final.system}".hyprlock;
  };

  nixpkgsoverlay =
    final: prev:
    let
      getPkgs = input: input.packages."${final.system}";
      masterPkgs = import inputs.trunk {
        system = final.system;
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
