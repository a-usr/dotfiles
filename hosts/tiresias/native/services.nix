{
  services.cloud-init = {
    enable = true;
    network.enable = true;
  };

  services.qemuGuest.enable = true;
}
