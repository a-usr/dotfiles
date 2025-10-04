{
  config,
  lib,
  global,
  ...
}:
let
  inherit (lib) mkOption mkIf;
in
{
  options.enable = mkOption {
    type = lib.types.bool;
    default = !global.headless;
  };

  config.global.internal.graphical = mkIf config.enable true;
  config.global.internal.wayland = mkIf config.enable true;

  config.nativeModule = mkIf config.enable (
    {
      inputs,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.hyprland.nixosModules.default
      ];

      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };
      programs.hyprland.enable = true;
      environment.systemPackages = [
        inputs.niqspkgs.packages."${global.system}".bibata-hyprcursor
      ];
    }
  );
}
