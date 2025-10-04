{ lib, hostConfig, ... }:
{
  nativeModule = {
    users.groups.sysconfig.members = [
      "usr"
    ];
    users.groups.steam.members = lib.mkIf hostConfig.extra.gaming.steam [
      "usr"
    ];
  };
}
