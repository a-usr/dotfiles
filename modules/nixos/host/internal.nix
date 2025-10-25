{
  lib,
  config,
  global,
  ...
}:
{
  options.graphical = lib.mkOption {
    type = lib.types.bool;
    default = !global.headless;
  };

  options.wayland = lib.mkOption {
    type = lib.types.bool;
    default = config.graphical;
  };

  config.nativeModule = (
    if config.wayland then
      { pkgs, ... }:
      {

        environment.systemPackages = with pkgs; [
          stash
        ];

      }
    else
      { }
  );
}
