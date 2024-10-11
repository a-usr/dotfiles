{inputs, ...}: let
  nixpkgsoverlay = final: prev: 
  let
    # unstablePkgs = import inputs.unstable {
    #   system = final.system;
    #   config = final.config;
    # };
    masterPkgs = import inputs.trunk {
      system = final.system;
      config = final.config;
      overlays = [trunkoverlay];
    };
  in 
  {
  #   unstable = unstablePkgs;
     master = masterPkgs;
  #   mesa = unstablePkgs.mesa;
  #
  };

  trunkoverlay = final: prev: {
    hyprlock = inputs.hyprlock.packages."${final.system}".hyprlock;
    hyprland = inputs.hyprland.packages."${final.system}".default;
    hyprwayland-scanner = prev.hyprwayland-scanner.overrideAttrs (finalAttrs: previousAttrs: {
      version = "0.3.10";
      src = final.fetchFromGitHub {
        owner = "hyprwm";
        repo = "hyprwayland-scanner";
        rev = "v${finalAttrs.version}";
        hash = "sha256-YxmfxHfWed1fosaa7fC1u7XoKp1anEZU+7Lh/ojRKoM=";
      };
    });
  };

in {
  nixpkgs.overlays = [
    nixpkgsoverlay
    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/emacs-overlay/archive/bb242817e911f6.tar.gz";
      sha256 = "0n10fx7d85pjv9gs5c8681vqglsl3sjn4jqdzk5yci4qzcgjq7kd";
    }))
  ];
}
