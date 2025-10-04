{
  description = "A shrimple NixOS flake";

  inputs = {
    mnw.url = "github:Gerg-L/mnw";
    # NixOS official package source, using the nixos-24.05 branch here
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    trunk.url = "github:NixOS/nixpkgs"; # Do I even use this anymore

    niqspkgs.url = "github:diniamo/niqspkgs";
    nixGaming.url = "github:fufexan/nix-gaming";

    ags.url = "github:Aylur/ags/v1.8.2";

    hyprland.url = "github:hyprwm/hyprland/v0.51.0";

    hyprlock.url = "github:hyprwm/Hyprlock";
    hyprlock.inputs.nixpkgs.follows = "nixpkgs";
    hy3 = {
      type = "github";
      owner = "outfoxxed";
      repo = "Hy3"; # where {version} is the hyprland release version
      ref = "hl0.51.0";
      inputs.hyprland.follows = "hyprland";
    };
    hyprpaper.url = "github:hyprwm/hyprpaper";
    hyprpicker.url = "github:hyprwm/hyprpicker";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hjem = {
      url = "github:feel-co/hjem";
      # You may want hjem to use your defined nixpkgs input to
      # minimize redundancies.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem-rum = {
      url = "github:snugnug/hjem-rum";
      # You may want hjem-rum to use your defined nixpkgs input to
      # minimize redundancies.
      inputs.nixpkgs.follows = "nixpkgs";
      # Same goes for hjem, to avoid discrepancies between the version
      # you use directly and the one hjem-rum uses.
      inputs.hjem.follows = "hjem";
    };
  };

  outputs =
    inputs:
    let
      lib = import ./lib;
      allModules = import ./modules { inherit lib; };
      mkNixosConfig' =
        args:
        lib.mkTopLevel inputs inputs.nixpkgs.lib.nixosSystem {
          modules = allModules.nixosModules ++ args.modules;
          specialArgs = { inherit inputs; };
        }
        // builtins.removeAttrs args [ "modules" ];
      mkNixosConfig =
        host:
        mkNixosConfig' {
          modules = (lib.getModulesFromDir (./hosts + "/${host}/modules")) ++ [
            {
              _file = "Native Module Imports";
              nativeModule.imports = lib.getModulesFromDir (./hosts + "/${host}/nativeModules") ++ [
                { networking.hostName = host; }
              ];
            }
          ];
        };

      mkPseudoConfig =
        host:
        mkPseudoConfig' {
          modules = (lib.getModulesFromDir (./hosts + "/${host}/modules")) ++ [
            {
              _file = "Native Module Imports";
              nativeModule.imports = lib.getModulesFromDir (./hosts + "/${host}/nativeModules");
            }
          ];
        };
      mkPseudoConfig' = # for debugging
        {
          modules ? [ ],
        }@args:
        lib.mkTopLevel inputs (args: args) {
          modules = allModules.nixosModules ++ modules;
        }
        // builtins.removeAttrs args [ "modules" ];
    in
    {
      inherit lib inputs allModules;
      nixpkgsLib = inputs.nixpkgs.lib;
      #lib = import ./overlays/lib.nix inputs;
      nixosConfigurations.ssd = import ./hosts/ssd inputs;
      nixosConfigurations.silenos = mkNixosConfig "silenos";
      pseudo = mkPseudoConfig' { };
      pseudo_host = mkPseudoConfig "silenos";
    };
}
