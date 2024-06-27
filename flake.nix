{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    trunk.url = "github:NixOS/nixpkgs";

    ags.url = "github:Aylur/ags";
   
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?ref=refs/tags/v0.41.1&submodules=1";
    
    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.41.1"; # where {version} is the hyprland release version
      # or "github:outfoxxed/hy3" to follow the development branch.
      # (you may encounter issues if you dont do the same for hyprland)
      inputs.hyprland.follows = "hyprland";
    };
    hyprpaper.url = "github:hyprwm/hyprpaper";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    lib = import ./overlays/lib.nix (inputs);
    nixosConfigurations.ssd = import ./hosts/ssd (inputs);
    nixosConfigurations.silenos = import ./hosts/silenos (inputs);
  };
}
