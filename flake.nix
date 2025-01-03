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

    #aquamarine.url = "github:hyprwm/aquamarine"; #"/07eb70afb131a4450aa01f5b488228c4cce6892b";
    hyprland.url = "github:hyprwm/hyprland/v0.44.0";
    #hyprland.inputs.nixpkgs.follows = "nixpkgs";
    #hyprland = {
    #  type = "git";
    #  url = "https://github.com/hyprwm/Hyprland/";
    #  #ref = "refs/tags/v0.42.0";
    #  rev = "9a09eac79b85c846e3a865a9078a3f8ff65a9259";
    #  submodules = true;
    #  #inputs.nixpkgs.follows = "unstable";
    #}; #&ref=explicit-sync&rev=158bbaaf88764e2a1e19ca1e3a11af541374432e";
    #hyprland.inputs.nixpkgs.follows = "unstable";
    #hyprland.inputs.aquamarine.follows = "aquamarine";

    hyprlock.url = "github:hyprwm/Hyprlock";
    hyprlock.inputs.nixpkgs.follows = "nixpkgs";
    hy3 = {
      type = "github";
      owner = "outfoxxed";
      repo = "Hy3"; # where {version} is the hyprland release version
      # or "github:outfoxxed/hy3" to follow the development branch.
      # (you may encounter issues if you dont do the same for hyprland
      # )
      ref = "hl0.44.0";
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
