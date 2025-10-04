{ ... }:
{
  fileSystems = {
    "/steamNTFS" = {
      device = "/dev/disk/by-uuid/2BC6A450746649CD";
      fsType = "ntfs-3g";
      options = [
        "rw"
        "uid=1000"
        "big_writes"
      ];
    };

    "/steam" = {
      device = "/dev/disk/by-uuid/3e267c4d-2c3b-4834-9a35-8db41e280a9f";
      fsType = "btrfs";
      options = [
        "subvol=steam"
      ];
    };

    "/epicgames" = {
      device = "/dev/disk/by-uuid/3e267c4d-2c3b-4834-9a35-8db41e280a9f";
      fsType = "btrfs";
      options = [ "subvol=epicgames" ];
    };
  };
}
