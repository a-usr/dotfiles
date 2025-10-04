{ lib }:
let
  inherit (builtins)
    filter
    readDir
    split
    length
    elemAt
    ;
in
rec {
  getItemsFromDir =
    itemType: dir:
    map (file: toString (dir + "/${file}")) (lib.getAttrsWithValue itemType (readDir dir));

  filterNixFiles = filenames: filter (name: (getFileExtension name) == "nix") filenames;

  getFileExtension =
    file:
    let
      splitted = (split "\\." file);
      len = length splitted;
    in
    (builtins.elemAt splitted (len - 1));

  getBaseName =
    file:
    let
      splitted = (split "/" file);
      len = length splitted;
    in
    (builtins.elemAt splitted (len - 1));
  getFileBaseNameWithoutExtension =
    file:
    let
      splitted = (split "\\." (getBaseName file));
      len = length splitted;
    in
    (builtins.elemAt splitted (len - 3));

}
