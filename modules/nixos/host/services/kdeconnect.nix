{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.enable = mkEnableOption "KDE Connect";

  config.nativeModule = mkIf config.enable {
    programs.kdeconnect.enable = true;
  };
}
