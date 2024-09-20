{inputs, ...}: let
  nixpkgsoverlay = final: prev: {
    unstable = import inputs.unstable {
      system = final.system;
      config = final.config;
    };
    master = import inputs.trunk {
      system = final.system;
      config = final.config;
      overlays = [trunkoverlay];
    };

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
      url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      sha256 = "0dx8qiki5c1p9g41i2r75fgxn9il6saxviakmgwp77xqbkkhd390";
    }))
  ];
}
