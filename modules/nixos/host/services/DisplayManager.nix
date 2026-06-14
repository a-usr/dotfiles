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
    { pkgs, ... }:
    {
      services.displayManager.ly = {
        enable = config.ly.enable;
        settings = {
          # setup_cmd =
          #   let
          #     inherit (lib) optionalString;
          #     nativeCfg = args.config;
          #   in
          #   toString (
          #     pkgs.writeScript "wlsession-wrapper" ''
          #       #! ${pkgs.bash}/bin/bash
          #
          #           # Shared environment setup for graphical sessions.
          #
          #           . /etc/profile
          #           if test -f ~/.profile; then
          #               source ~/.profile
          #           fi
          #
          #           cd "$HOME"
          #
          #           # Allow the user to execute commands at the beginning of the X session.
          #           if test -f ~/.xprofile; then
          #               source ~/.xprofile
          #           fi
          #
          #           ${optionalString nativeCfg.services.displayManager.logToJournal ''
          #             if [ -z "$_DID_SYSTEMD_CAT" ]; then
          #               export _DID_SYSTEMD_CAT=1
          #               exec ${nativeCfg.systemd.package}/bin/systemd-cat -t xsession "$0" "$@"
          #             fi
          #           ''}
          #
          #           ${optionalString nativeCfg.services.displayManager.logToFile ''
          #             exec &> >(tee ~/.xsession-errors)
          #           ''}
          #
          #
          #           # Import environment variables into the systemd user environment.
          #           ${optionalString (nativeCfg.services.xserver.displayManager.importedVariables != [ ]) (
          #             "/run/current-system/systemd/bin/systemctl --user import-environment "
          #             + toString (lib.unique nativeCfg.services.xserver.displayManager.importedVariables)
          #           )}
          #
          #           # Speed up application start by 50-150ms according to
          #           # https://kdemonkey.blogspot.com/2008/04/magic-trick.html
          #           compose_cache="''${XCOMPOSECACHE:-$HOME/.compose-cache}"
          #           mkdir -p "$compose_cache"
          #           # To avoid accidentally deleting a wrongly set up XCOMPOSECACHE directory,
          #           # defensively try to delete cache *files* only, following the file format specified in
          #           # https://gitlab.freedesktop.org/xorg/lib/libx11/-/blob/master/modules/im/ximcp/imLcIm.c#L353-358
          #           # sprintf (*res, "%s/%c%d_%03x_%08x_%08x", dir, _XimGetMyEndian(), XIM_CACHE_VERSION, (unsigned int)sizeof (DefTree), hash, hash2);
          #           ${pkgs.findutils}/bin/find "$compose_cache" -maxdepth 1 -regextype posix-extended -regex '.*/[Bl][0-9]+_[0-9a-f]{3}_[0-9a-f]{8}_[0-9a-f]{8}' -delete
          #           unset compose_cache
          #
          #           # Work around KDE errors when a user first logs in and
          #           # .local/share doesn't exist yet.
          #           mkdir -p "''${XDG_DATA_HOME:-$HOME/.local/share}"
          #
          #           unset _DID_SYSTEMD_CAT
          #
          #           ${nativeCfg.services.xserver.displayManager.sessionCommands}
          #
          #           if test "$1"; then
          #               # Run the supplied session command. Remove any double quotes with eval.
          #               eval exec "$@"
          #           else
          #               # TODO: Do we need this? Should not the session always exist?
          #               echo "error: unknown session $1" 1>&2
          #               exit 1
          #           fi
          #       				''
          #   );
        };
      };
      security.pam.services.ly.u2fAuth = config.ly.enable;
      # systemd.services.display-manager.environment.XDG_CURRENT_DESKTOP = "X-NIXOS-SYSTEMD-AWARE";
    }
  );
}
