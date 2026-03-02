{ hostConfig, ... }:
{
  groups = [
    "sysconfig"
    "minecraft"
    "wheel"
    "networkmanager"
    "localhost"
    "scanner"
    "lp"
  ]
  ++ (if hostConfig.extra.gaming.steam then [ "steam" ] else [ ]);
}
