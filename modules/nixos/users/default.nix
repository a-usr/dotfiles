{
  config,
  lib',
  lib,
  inputs,
  ...
}:
let
  inherit (builtins) readDir concatMap listToAttrs;
  inherit (lib)
    mkEnableOption
    mkOption
    types
    ;
  inherit (lib') getAttrsWithValue getModulesFromDir mkNativeModuleOption;
  userDirs = getAttrsWithValue "directory" (readDir ./.);
  mkUserModule =
    user:
    types.submoduleWith {
      specialArgs = {
        hostConfig = config;
        inherit lib' inputs;
      };
      modules = [
        {
          options = {
            enable = mkEnableOption "Enable the user ${user}";
            nativeModule = mkNativeModuleOption lib;
          };

        }
      ] ++ (getModulesFromDir (./. + "/${user}"));
    };
in
{
  options.users = listToAttrs (
    map (user: {
      name = user;
      value = mkOption {
        type = mkUserModule user;
        default = { };
      };
    }) userDirs
  );
  config.nativeModule.imports = concatMap (
    user: if config.users."${user}".enable then [ config.users."${user}".nativeModule ] else [ ]
  ) userDirs;

}
