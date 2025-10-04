{ lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) package str;
in
{
  options.programs = {
    browser = mkOption {
      type = package;
    };
  };

}
