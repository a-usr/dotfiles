{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager ,... }@inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations.ssd = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix
        ./home/usr
        home-manager.nixosModules.home-manager
        {
          home-manager.useUserPackages = true;

          home-manager.users.usr = import ./home/usr/home.nix ;
        }
      ];
    };
  };
}
