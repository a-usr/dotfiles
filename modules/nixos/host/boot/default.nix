{ lib, config, ... }:
{
  options.canHasNtfs = lib.mkEnableOption "Enable NTFS Support";
  config.nativeModule = {
    boot = {
      supportedFilesystems = lib.optionals config.canHasNtfs [ "ntfs" ];
    };
  };
}
