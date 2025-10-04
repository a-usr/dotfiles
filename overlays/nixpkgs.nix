{ inputs, ... }:
let
  master_overlay = final: prev: {
    hyprlock = inputs.hyprlock.packages."${final.system}".hyprlock;
  };

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
in
{
  nixpkgs.overlays = [
    nixpkgsoverlay
  ];
}
