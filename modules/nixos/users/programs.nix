{ lib, config, ... }:
let
  inherit (lib) mkOption mkIf pipe;
  inherit (lib.types) nullOr package str;
in
{
  options.programs = {
    browser = mkOption {
      type = nullOr package;
      default = null;
    };
    terminal = mkOption {
      type = nullOr package;
      default = null;
    };
  };

  config.userModule.packages = pipe config.programs [
    builtins.attrValues
    (builtins.filter (v: v != null))
  ];

}
