{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    types
    ;
in
{
  options = {
    headless = mkEnableOption "Headless";

    system = mkOption {
      type = types.str;
      default = "x86_64-linux";
    };
  };
  config.nativeModule = (
    args: {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        inputs.hjem.nixosModules.default
      ];
      hjem = {extraModules = [
        inputs.hjem-rum.hjemModules.default
      ];
      specialArgs = { inherit inputs; }; 
			linker = inputs.hjem.packages.${config.system}.smfh;
			};

      home-manager = {
        extraSpecialArgs = {
          inherit inputs;
        };
        useUserPackages = true;
        useGlobalPkgs = true;
      };

      nixpkgs.hostPlatform = config.system;
    }
  );
}
