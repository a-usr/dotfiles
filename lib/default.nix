let
  mkRec =
    attrs:
    let
      self = attrs self;
    in
    self;
in
mkRec (
  self:
  let
    callLib = file: import file { lib = self; };
  in
  {
    inherit mkRec;
    inherit (callLib ./attrs.nix) filterAttrs getAttrsWithValue;
    inherit (callLib ./path.nix)
      getItemsFromDir
      filterNixFiles
      getBaseName
      getFileBaseNameWithoutExtension
      ;
    inherit (callLib ./lists.nix) toList;
    inherit (callLib ./ModuleSystem.nix)
      mkNativeModuleOption
      mkTopLevel
      getModulesFromDir
      getModulesRecursive
      ;
  }
)
