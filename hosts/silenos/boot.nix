{ config, ... }:
{
  boot = {
    kernel.sysctl = {
      "kernel.unprivileged_userns_clone" = 1;
    };
    supportedFilesystems = [ "ntfs" ];
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback.out ];
    kernelModules = [
      "v4l2loopback"
      "ecryptfs"
    ];
    extraModprobeConfig = ''
      options v4l2loopback card_label="LoopBack" exclusive_caps=1
    '';
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
