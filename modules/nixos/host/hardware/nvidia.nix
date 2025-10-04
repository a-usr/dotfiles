{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.enable = mkEnableOption "Nvidia Drivers";

  config.global.nixpkgs.allowedUnfreePackages = mkIf config.enable [
    "nvidia-x11"
    "nvidia-settings"
  ];

  config.nativeModule = mkIf config.enable (
    { config, ... }:
    {

      services.xserver.videoDrivers = [ "nvidia" ];
      hardware = {
        nvidia = {
          modesetting.enable = true;

          powerManagement.enable = false;
          powerManagement.finegrained = false;

          open = true;
          package = config.boot.kernelPackages.nvidiaPackages.beta;
        };

        graphics = {
          enable = true;
          enable32Bit = true;
        };
      };
    }
  );
}
