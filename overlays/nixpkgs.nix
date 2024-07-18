{ inputs, ... }:
let 
  nixpkgsoverlay = final: prev: {
    unstable = import inputs.unstable { system = final.system; config = final.config; };
    trunk = import inputs.trunk { system = final.system; config = final.config; overlays = [ trunkoverlay ];};

  };

  trunkoverlay = final: prev: {
    hyprlock = inputs.hyprlock.packages."${final.system}".hyprlock;
    hyprland = inputs.hyprland.packages."${final.system}".default;
    hyprwayland-scanner = prev.hyprwayland-scanner.overrideAttrs ( finalAttrs: previousAttrs: {
      version = "0.3.10";
      src = final.fetchFromGitHub {
        owner = "hyprwm";
        repo = "hyprwayland-scanner";
        rev = "v${finalAttrs.version}";
        hash = "sha256-YxmfxHfWed1fosaa7fC1u7XoKp1anEZU+7Lh/ojRKoM=";
      };
    });
  };
in
{
  nixpkgs.overlays = [ nixpkgsoverlay ];
}
