{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    trunk.url = "github:NixOS/nixpkgs";
    
    ags.url = "github:Aylur/ags";
    
    hyprpaper.url = "github:hyprwm/hyprpaper";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager ,... }@inputs: {
    overlays = {
      # Inject 'unstable' and 'trunk' into the overridden package set, so that
      # the following overlays may access them (along with any system configs
      # that wish to do so).
      pkg-sets = (
        final: prev: {
          unstable = import inputs.unstable { system = final.system; };
          trunk = import inputs.trunk { system = final.system; };
        }
      );
    };

    nixosConfigurations.ssd = import ./hosts/ssd (inputs);
  };
}
