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
      glfw3 = prev.glfw3.overrideAttrs (prevAttrs: {
        patches = prevAttrs.patches ++ [ ./glfw3-segfault.patch ];
      });
      glfw3-minecraft = prev.glfw3-minecraft.overrideAttrs (prevAttrs: {
        patches = prevAttrs.patches ++ [ ./glfw3-segfault.patch ];
      });
    };
in
[
  nixpkgsoverlay
]
