{ lib }:
let
  inherit (builtins)
    filter
    attrNames
    ;

  filterAttrs = pred: set: removeAttrs set (filter (name: !pred name set.${name}) (attrNames set)); # yanked from nixpkgs
  getAttrsWithValue = val: attrs: attrNames (filterAttrs (name: value: value == val) attrs);
in
{

  filterAttrs = filterAttrs;
  getAttrsWithValue = getAttrsWithValue;

}
