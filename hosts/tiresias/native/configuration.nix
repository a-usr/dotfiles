{
  # networking.nameservers = [
  #   "2a00:1098:2b::1"
  #   "2a01:4f8:c2c:123f::1"
  #   "2a00:1098:2c::1"
  # ];

  boot.loader.grub.device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";

  # HACK: because Contabo's network conf hardcodes eth0, making cloud-init generate an additional empty rule
  networking.usePredictableInterfaceNames = false;

  nix.settings.trusted-users = [ "usr" ];
  system.stateVersion = "26.05";
}
