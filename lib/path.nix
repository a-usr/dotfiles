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
    itemType: dir: map (file: (dir + "/${file}")) (lib.getAttrsWithValue itemType (readDir dir));

  filterFileTypes = fts: filter (name: builtins.any (ft: (getFileExtension name) == ft) fts);

  filterFileType = ft: filterFileTypes [ ft ];

  filterNixFiles = filterFileType "nix";

  getFileExtension =
    file:
    let
      file_ = toString file;
      splitted = (split "\\." (file_));
      len = length splitted;
    in
    (builtins.elemAt splitted (len - 1));

  getBaseName =
    file:
    let
      file_ = toString file;
      splitted = (split "/" file_);
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
