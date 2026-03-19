{ lib }:
rec {
  startsWith =
    prefix: value:
    let
      inherit (builtins) stringLength substring;
      prefixLen = stringLength prefix;
    in
    if prefixLen > (stringLength value) then false else prefix == (substring 0 prefixLen value);
}
