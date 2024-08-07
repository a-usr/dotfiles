{...}: {
  boot = {
    kernelModules = ["v4l2loopback"];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
      systemd-boot = {
        enable = true;
        netbootxyz.enable = true;
      };
    };
  };
}
