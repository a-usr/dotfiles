{
  description = "A shrimple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.05 branch here
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    trunk.url = "github:NixOS/nixpkgs";

    niqspkgs.url = "github:diniamo/niqspkgs";
    nixGaming.url = "github:fufexan/nix-gaming";

    ags.url = "github:Aylur/ags/v1.8.2";

    hyprland.url = "github:hyprwm/hyprland/v0.47.0";

    hyprlock.url = "github:hyprwm/Hyprlock";
    hyprlock.inputs.nixpkgs.follows = "nixpkgs";
    hy3 = {
      type = "github";
      owner = "outfoxxed";
      repo = "Hy3"; # where {version} is the hyprland release version
      ref = "hl0.47.0";
      inputs.hyprland.follows = "hyprland";
    };
    nixvim = {
      url = "github:nix-community/nixvim?ref=nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpaper.url = "github:hyprwm/hyprpaper";
    hyprpicker.url = "github:hyprwm/hyprpicker";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: {
    #lib = import ./overlays/lib.nix inputs;
    nixosConfigurations.ssd = import ./hosts/ssd inputs;
    nixosConfigurations.silenos = import ./hosts/silenos inputs;
  };
}
