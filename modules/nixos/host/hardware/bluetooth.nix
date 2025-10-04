{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.enable = mkEnableOption "bluetooth";
  config.nativeModule = mkIf config.enable {
    hardware = {
      bluetooth = {
        enable = true;
        # necessary for bluetooth battery reporting
        settings.General.Experimental = true;
      };
    };
  };
}
