{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.enable = mkEnableOption "ecryptfs";
  config.nativeModule = mkIf config.enable (
    { pkgs, ... }:
    {
      boot.kernelModules = [
        "ecryptfs"
      ];
      environment.systemPackages = [ pkgs.ecryptfs ];
    }
  );
}
