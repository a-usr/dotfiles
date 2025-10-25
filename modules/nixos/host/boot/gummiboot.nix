{ config, lib, ... }:
{
  options.enable = lib.mkEnableOption "systemd-boot";
  config.nativeModule = lib.mkIf config.enable (
    { config, ... }:
    {
      boot = {
        loader = {
          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/efi";
          };
          systemd-boot = {
            enable = true;
            netbootxyz.enable = true;
          };
        };
      };
    }
  );
}
