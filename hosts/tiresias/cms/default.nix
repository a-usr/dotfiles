{
  headless = true;
  services.networkmanager.enabled = false;
  users.usr = {
    enable = true;
    trustedUser = true;
  };
  nixpkgs.allowedUnfreePackages = [
    "minecraft-server"
    "neoforge"
  ];
}
