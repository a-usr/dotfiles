{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mapAttrsToList
    mkIf
    ;

  maybeModules = {
    steam = {
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
    };
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
      "xow_dongle-firmware"
    ];
  };

  sanitizedConfig = builtins.removeAttrs config [
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

  config.global.nixpkgs.allowedUnfreePackages = builtins.concatLists (
    mapAttrsToList (name: value: if value then maybeAllowedPackages."${name}" else [ ]) sanitizedConfig

  );

  config.nativeModule.imports = mapAttrsToList (
    name: value: mkIf value maybeModules."${name}"
  ) sanitizedConfig;
}
