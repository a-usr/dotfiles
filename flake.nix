{
  description = "A shrimple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    trunk.url = "github:NixOS/nixpkgs";

    niqspkgs.url = "github:diniamo/niqspkgs";
    nixGaming.url = "github:fufexan/nix-gaming";

    ags.url = "github:Aylur/ags";

    #aquamarine.url = "github:hyprwm/aquamarine"; #"/07eb70afb131a4450aa01f5b488228c4cce6892b";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland/?submodules=1&ref=v0.42.0"; #&ref=explicit-sync&rev=158bbaaf88764e2a1e19ca1e3a11af541374432e";
    hyprland.inputs.nixpkgs.follows = "unstable";
    #hyprland.inputs.aquamarine.follows = "aquamarine";

    hyprlock.url = "github:hyprwm/Hyprlock";
    hyprlock.inputs.nixpkgs.follows = "nixpkgs";
    hy3 = {
      url = "github:outfoxxed/hy3"; # where {version} is the hyprland release version
      # or "github:outfoxxed/hy3" to follow the development branch.
      # (you may encounter issues if you dont do the same for hyprland)
      inputs.hyprland.follows = "hyprland";
    };
    nixvim = {
      url = "github:nix-community/nixvim?ref=nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix.url = "github:helix-editor/helix";

    hyprpaper.url = "github:hyprwm/hyprpaper";
    hyprpicker.url = "github:hyprwm/hyprpicker";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: {
    lib = import ./overlays/lib.nix inputs;
    nixosConfigurations.ssd = import ./hosts/ssd inputs;
    nixosConfigurations.silenos = import ./hosts/silenos inputs;
  };
}
