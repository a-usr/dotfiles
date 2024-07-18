{...}: {
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/efi";
    };
    systemd-boot = {
      enable = true;
      netbootxyz.enable = true;
    };
  };
}
