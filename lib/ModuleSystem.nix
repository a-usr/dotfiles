args:
let
  lib' = args.lib; # Do this because we might start confusing nixpkgs lib with our own later
  inherit (builtins)
    concatMap
    removeAttrs
    ;

in
rec {

  mkNativeModuleOption =
    lib:
    lib.mkOption {
      type = lib.types.deferredModule;
      default = { };
    };

  _moduleOptions = lib: {
    nativeModule = mkNativeModuleOption lib;
    global = lib.mkOption {
      type = lib.types.deferredModule;
      default = { };
    };
  };

  # Evaluate a set of options in two passes
  mkTopLevel =
    { nixpkgs, ... }@inputs:
    evalModulesFinal:
    {
      modules,
      specialArgs ? { },
    }@args:
    let
      lib = nixpkgs.lib;

      extractGlobalValues =
        globalModule:
        (lib.evalModules {
          modules = [
            { freeformType = lib.types.attrs; }
            globalModule
          ];
        }).config;

      iterate =
        prevGlobalModule:
        lib.evalModules {
          modules = modules ++ [
            { options = _moduleOptions lib; }
            {
              _module.args = {
                inherit inputs lib lib';
              }
              // specialArgs;
            }
            prevGlobalModule
          ];
        };

      converge =
        prevGlobalModule: prevValues: limit:
        if limit == 0 then
          throw "Module evaluation did not converge after iteration limit"
        else
          let
            current = iterate prevGlobalModule;
            currentValues = extractGlobalValues current.config.global;
          in
          if currentValues == prevValues then
            current # Converged
          else
            converge current.config.global currentValues (limit - 1);

      moduleResult = converge { } { } 100;
      # moduleResult = lib'.mkRec (
      #   self:
      #   lib.evalModules {
      #     modules = modules ++ [
      #       {
      #         options = _moduleOptions lib;
      #       }
      #       {
      #         _module.args = {
      #           inherit inputs lib lib';
      #         } // specialArgs;
      #       }
      #       self.config.global
      #     ];
      #   }
      #   // removeAttrs args [
      #     "modules"
      #     "specialArgs"
      #   ]
      # );
    in
    evalModulesFinal {

      specialArgs = {
        inherit inputs;
      };

      modules = [
        moduleResult.config.nativeModule
      ];

    };

  getModulesFromDir =
    dir:
    let
      ImmediateImports = lib'.getItemsFromDir "regular" dir;

      SubdirImports = lib'.filterNixFiles (
        concatMap (dir: lib'.getItemsFromDir "regular" dir) (lib'.getItemsFromDir "directory" dir)
      );
    in
    ImmediateImports ++ SubdirImports;

  # This function does the actual namespacing
  getModulesRecursive =
    {
      dir,
      extraModules ? [ ],
    }:
    let
      mkModule =
        { nsName, modules }:
        {
          config,
          lib,
          ...
        }@args:
        let
          global = args.global or config;
        in
        {
          _file = "module for namespace '${nsName}' injected by ${__curPos.file}:${toString __curPos.line}";
          options."${nsName}" = lib.mkOption {
            default = { };
            type = lib.types.submoduleWith {
              specialArgs = {
                inherit lib' global;
              };

              modules = [
                {
                  options = _moduleOptions lib;
                }
              ]
              ++ extraModules
              ++ modules;
            };
          };
          config = {
            nativeModule = config."${nsName}".nativeModule;
            global = config."${nsName}".global;
          };
        };

      NixFiles = lib'.filterNixFiles (lib'.getItemsFromDir "regular" dir);
      Directories = lib'.getItemsFromDir "directory" dir;

      NixModules = map (
        file:
        let
          nsName = lib'.getFileBaseNameWithoutExtension file;
          modules = [ file ];
        in
        (
          if (lib'.getBaseName file) == "default.nix" then
            file
          else
            mkModule {
              inherit nsName modules;
            }
        )
      ) NixFiles;

      DirModules = map (
        dir:
        let
          nsName = lib'.getBaseName dir;
          modules = getModulesRecursive { inherit dir; };
        in
        mkModule {
          inherit nsName modules;
        }
      ) Directories;

    in
    NixModules ++ DirModules;

}
