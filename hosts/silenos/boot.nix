{...}: {
  boot.loader = {
    kernelModules = ["v4l2loopback"];
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
