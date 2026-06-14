{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.enable = mkEnableOption "DAW support";
  config.nativeModule = mkIf config.enable {

    security.pam.loginLimits = [
      {
        domain = "@audio";
        type = "-";
        item = "memlock";
        value = "unlimited";
      }
      {
        domain = "@audio";
        type = "-";
        item = "rtprio";
        value = "99";
      }
    ];
  };
}
