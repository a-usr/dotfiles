{
  # networking.nameservers = [
  #   "2a00:1098:2b::1"
  #   "2a01:4f8:c2c:123f::1"
  #   "2a00:1098:2c::1"
  # ];

  boot.loader.grub.device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
  networking = {

    # HACK: because Contabo's network conf hardcodes eth0, making cloud-init generate an additional empty rule
    usePredictableInterfaceNames = false;
    # Fuck them Scanners
    firewall.extraCommands = ''
      iptables -I INPUT -m state --state NEW -m recent --name PORTSCAN --rcheck --seconds 30 --hitcount 5 -j DROP
      iptables -A INPUT -m state --state NEW -m recent --name PORTSCAN --set
    '';
  };

  networking.useNetworkd = true;

  nix.settings.trusted-users = [ "usr" ];
  system.stateVersion = "26.05";
}
