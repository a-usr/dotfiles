{
  config,
  global,
  lib,
  ...
}:
{
  options = {
    ly.enable = lib.mkOption {
      type = lib.types.bool;
      default = global.internal.graphical;
    };
  };

  config.nativeModule = (
    { pkgs, ... }@args:
    {
      services.displayManager.ly = {
        enable = config.ly.enable;
        settings = {
          setup_cmd =
            let
              inherit (lib) optionalString;
              nativeCfg = args.config;
            in
            toString (
              pkgs.writeScript "wlsession-wrapper" ''
                #! ${pkgs.bash}/bin/bash

                    # Shared environment setup for graphical sessions.

                    . /etc/profile
                    if test -f ~/.profile; then
                        source ~/.profile
                    fi

                    cd "$HOME"

                    # Allow the user to execute commands at the beginning of the X session.
                    if test -f ~/.xprofile; then
                        source ~/.xprofile
                    fi

                    ${optionalString nativeCfg.services.displayManager.logToJournal ''
                      if [ -z "$_DID_SYSTEMD_CAT" ]; then
                        export _DID_SYSTEMD_CAT=1
                        exec ${nativeCfg.systemd.package}/bin/systemd-cat -t xsession "$0" "$@"
                      fi
                    ''}

                    ${optionalString nativeCfg.services.displayManager.logToFile ''
                      exec &> >(tee ~/.xsession-errors)
                    ''}


                    # Import environment variables into the systemd user environment.
                    ${optionalString (nativeCfg.services.xserver.displayManager.importedVariables != [ ]) (
                      "/run/current-system/systemd/bin/systemctl --user import-environment "
                      + toString (lib.unique nativeCfg.services.xserver.displayManager.importedVariables)
                    )}

                    unset _DID_SYSTEMD_CAT

                    ${nativeCfg.services.xserver.displayManager.sessionCommands}

                    if test "$1"; then
                        # Run the supplied session command. Remove any double quotes with eval.
                        eval exec "$@"
                    else
                        # TODO: Do we need this? Should not the session always exist?
                        echo "error: unknown session $1" 1>&2
                        exit 1
                    fi
                				''
            );
        };
      };
      security.pam.services.ly.u2fAuth = config.ly.enable;
      # systemd.services.display-manager.environment.XDG_CURRENT_DESKTOP = "X-NIXOS-SYSTEMD-AWARE";
    }
  );
}
