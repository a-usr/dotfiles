{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    ags.url = "github:Aylur/ags";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager ,... }@inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations.ssd = import ./hosts/ssd (inputs);
  };
}
