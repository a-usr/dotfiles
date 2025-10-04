{ config, lib, ... }:
let
  inherit (lib) mkOption mkIf types;
in
{
  options = {
    allowedUnfreePackages = mkOption {
      type = types.listOf types.str;
      default = [ ];

    };

    allowUnfreePredicate = mkOption {
      type = types.raw;
      default = (pkg: builtins.elem (lib.getName pkg) config.allowedUnfreePackages);

    };
  };

}
