{ config, lib, ... }:
{
  options.enable = lib.mkEnableOption "Secure Boot";
  config = lib.mkIf config.enable {
    nativeModule = (
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.sbctl ];

        boot.loader.systemd-boot.enable = lib.mkForce false;

        boot.lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
        };
      }
    );
  };
}
