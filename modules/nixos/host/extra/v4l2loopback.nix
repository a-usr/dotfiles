{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{

  options.enable = mkEnableOption "v4l2loopback";
  config.nativeModule = mkIf config.enable (
    { config, ... }:
    {
      boot = {
        kernelModules = [
          "v4l2loopback"
        ];

        extraModulePackages = [ config.boot.kernelPackages.v4l2loopback.out ];
        extraModprobeConfig = ''
          options v4l2loopback card_label="LoopBack" exclusive_caps=1
        '';
      };

    }
  );
}
