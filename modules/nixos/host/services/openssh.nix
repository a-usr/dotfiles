{ config, lib, ... }:
let
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    mkMerge
    types
    ;
in
{
  options = {
    enabled = mkOption {
      type = types.bool;
      default = true;
    };
    tarpit = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config.nativeModule = mkIf config.enabled (mkMerge [
    {
      services.openssh = {
        enable = true;
        settings.DenyUsers = [ "root" ];
        settings.PasswordAuthentication = false;
      };
    }
    (mkIf config.tarpit {
      services = {
        openssh.ports = [ 1023 ];

        endlessh-go = {
          enable = true;
          port = 22;
          openFirewall = true;
          # };
          # prometheus = {
          #   enable = true;
          #   listenAddress = "127.0.0.1";
          # };
          # extraOptions = [
          #   "-geoip_supplier ip-api"
          # ];
        };
      };
    })
  ]);
}
