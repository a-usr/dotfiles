{ lib, config, ... }:
{
  options.enabled = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable Networkmanager";
  };

  config.nativeModule = {

    networking.networkmanager = {
      enable = config.enabled; # Easiest to use and most distros use this by default.
      plugins = lib.mkForce [ ];
    };
  };
}
