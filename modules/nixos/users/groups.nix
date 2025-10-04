{ lib, config, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) listOf str;
in
{
  options.groups = mkOption {
    default = [ ];
    type = listOf str;
  };

  config.userModule.extraGroups = config.groups;

}
