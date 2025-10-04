{ config, lib, ... }:
let
  inherit (lib) mkOption mkIf types;
in
{
  options.allowedUnfreePackages = mkOption {
    type = types.listOf types.str;
    default = [ ];
  };

  # check if list is non-empty
  config.nativeModule = {
    nixpkgs = {
      config.allowUnfreePredicate = mkIf (builtins.any (_: true) config.allowedUnfreePackages) (
        pkg: builtins.elem (lib.getName pkg) config.allowedUnfreePackages
      );

    };
    imports = [ ../../../overlays/nixpkgs.nix ];
  };
}
