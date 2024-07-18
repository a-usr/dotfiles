{ ... }:
{
  fileSystems."/steam" = {
    device = "/dev/disk/by-uuid/3e267c4d-2c3b-4834-9a35-8db41e280a9f";
    fsType = "btrfs";
    options = [ "subvol=steam" ];
  };
  fileSystems."/epicgames" = {
    device = "/dev/disk/by-uuid/3e267c4d-2c3b-4834-9a35-8db41e280a9f";
    fsType = "btrfs";
    options = [ "subvol=epicgames" ];
  };
}
