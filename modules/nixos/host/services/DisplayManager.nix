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

  config.nativeModule = {
    services.displayManager.ly.enable = config.ly.enable;
    security.pam.services.ly.u2fAuth = config.ly.enable;
  };
}
