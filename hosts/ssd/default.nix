{nixpkgs, home-manager, ...}@inputs:
nixpkgs.lib.nixosSystem {
  specialArgs = {
    inherit inputs;
  };
  system = "x86_64-linux";
  modules = [
    home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.useUserPackages = true;
        }
    # Import the previous configuration.nix we used,
    # so the old configuration file still takes effect
    ./configuration.nix
    ./users
  ];
}
