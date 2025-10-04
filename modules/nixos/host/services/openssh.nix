{ config, lib, ... }:
let
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    types
    ;
in
{
  options = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
    tarpit = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config.nativeModule = mkIf config.enable (
    {
      services.openssh = {
        enable = true;
      };
    }
    // (
      if config.tarpit then
        {
          services = {
            openssh.ports = [ 1023 ];

            endlessh-go = {
              enable = true;
              port = 22;
              openFirewall = true;
              # prometheus = {
              #   enable = true;
              #   listenAddress = "127.0.0.1";
              # };
              # extraOptions = [
              #   "-geoip_supplier ip-api"
              # ];
            };
          };
        }
      else
        { }
    )
  );
}
