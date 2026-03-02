{
  headless = true;
  boot.secure-boot.enable = true;

  users.usr.enable = true;
  nixpkgs.allowedUnfreePackages = [
    "minecraft-server"
  ];
}
