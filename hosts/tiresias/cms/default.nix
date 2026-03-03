{
  headless = true;
  services.networkmanager.enabled = false;
  users.usr.enable = true;
  nixpkgs.allowedUnfreePackages = [
    "minecraft-server"
  ];
}
