{
  config,
  global,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    ;
in
{
  options = {
    kbLayout = mkOption {
      type = types.str;
      default = "us";
    };
    sound = mkOption {
      type = types.bool;
      default = global.internal.graphical;
    };
  };

  config.nativeModule = mkIf config.sound {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

}
