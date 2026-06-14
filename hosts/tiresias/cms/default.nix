{
  headless = true;
  services.networkmanager.enabled = false;
  services.reboot.schedule = "mon *-*-* 02:00:00";

  users.usr = {
    enable = true;
    trustedUser = true;
  };
  nixpkgs.allowedUnfreePackages = [
    "minecraft-server"
    "neoforge"
  ];
}
