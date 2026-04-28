{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mapAttrsToList
    ;
  inherit (builtins) filter concatLists;

  maybeModules = {
    steam = (
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.mangohud ];
        boot.kernelModules.ntsync = true;
        programs.steam = {
          enable = true;
          remotePlay.openFirewall = true;
          gamescopeSession.enable = true;
          # extraPackages = with pkgs; [
          #   libgdiplus
          #   keyutils
          #   libkrb5
          #   libpng
          #   libpulseaudio
          #   libvorbis
          #   stdenv.cc.cc.lib
          #   xorg.libXcursor
          #   xorg.libXi
          #   xorg.libXinerama
          #   xorg.libXScrnSaver
          # ];
        };
      }
    );
    controllerSupport = {
      hardware = {
        xone = {
          enable = true;
        };

        xpadneo = {
          enable = true;
        };
      };
    };
  };

  maybeAllowedPackages = {
    steam = [
      "steam"
      "steam-unwrapped"
      "steam-original"
      "steam-run"
    ];
    controllerSupport = [
      "xone-dongle-firmware"
    ];
  };

  sanitizedConfig = removeAttrs config [
    "_module"
    "global"
    "nativeModule"
  ];
in
{
  options = {
    steam = mkEnableOption "the Steam Client";
    controllerSupport = mkOption {
      type = types.bool;
      default = config.steam;
      description = "Whether to enable support for xbox controllers.";
    };
  };

  config.global.nixpkgs.allowedUnfreePackages = concatLists (
    mapAttrsToList (name: value: if value then maybeAllowedPackages."${name}" else [ ]) sanitizedConfig

  );

  config.nativeModule.imports = filter (v: v != null) (
    mapAttrsToList (name: value: if value then maybeModules."${name}" else null) sanitizedConfig
  );
}
