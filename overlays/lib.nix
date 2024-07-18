{inputs, ...}:
inputs.nixpkgs.lib.extend (
  final: prev: let
    storeFileName = path: let
      # All characters that are considered safe. Note "-" is not
      # included to avoid "-" followed by digit being interpreted as a
      # version.
      safeChars =
        ["+" "." "_" "?" "="]
        ++ lowerChars
        ++ upperChars
        ++ stringToCharacters "0123456789";

      empties = l: genList (x: "") (length l);

      unsafeInName =
        stringToCharacters (replaceStrings safeChars (empties safeChars) path);

      safeName = replaceStrings unsafeInName (empties unsafeInName) path;
    in
      "cfg_" + safeName;
  in {
    file.mkOutOfStorageSymlink = path: let
      pathStr = toString path;
      name = storeFileName (baseNameOf pathStr);
    in
      pkgs.runCommandLocal name {} ''ln -s ${lib.escapeShellArg pathStr} $out'';
  }
)
