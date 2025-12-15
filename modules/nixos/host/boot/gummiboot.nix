{ config, lib, ... }:
{
  options.enable = lib.mkEnableOption "systemd-boot";
  config.nativeModule = lib.mkIf config.enable (
    { config, ... }:
    {
      boot = {
        loader = {
          systemd-boot = {
            enable = true;
            netbootxyz.enable = true;
          };
        };
      };
    }
  );
}
