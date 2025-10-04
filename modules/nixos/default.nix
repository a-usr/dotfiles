lib':
(lib'.getModulesRecursive { dir = ./host; })
++ [
  (
    {
      config,
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
      inherit (lib') getAttrsWithValue getModulesFromDir;
      userBase = ../../users;

      userDirs = getAttrsWithValue "directory" (readDir userBase);
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
                userModule = lib.mkOption {
                  type = types.deferredModule;
                  default = { };
                };
                hjrModule = lib.mkOption {
                  type = types.deferredModule;
                  default = { };
                };
                hmModule = lib.mkOption {
                  type = types.deferredModule;
                  default = { };
                };
              };

            }
          ]
          ++ (getModulesFromDir ./users)
          ++ (getModulesFromDir (userBase + "/${user}/cms"));
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
        user:
        let
          userConfig = config.users.${user};
        in
        if userConfig.enable then
          [
            (
              { pkgs, ... }:
              {
                _file = "User module for user '${user}' injected at ${__curPos.file}:${toString __curPos.line}";
                hjem.users."${user}" = {
                  enable = true;
                  imports = getModulesFromDir (userBase + "/${user}/hjr") ++ [
                    {
                      _module.args = { inherit userConfig; };
                    }
                  ];
                };
                home-manager.users."${user}" = {
                  imports = getModulesFromDir (userBase + "/${user}/hm") ++ [

                    {
                      _module.args = { inherit userConfig; };
                    }
                  ];

                };
                users.users."${user}" =
                  { ... }:
                  {
                    imports = [ userConfig.userModule ];
                    _module.args.pkgs = pkgs;
                  };
              }
            )
          ]
        else
          [ ]
      ) userDirs;

    }

  )
]
