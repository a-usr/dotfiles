{
  desktops.hyprland.enable = true;
  extra = {
    v4l2loopback.enable = true;
    gaming.steam = true;
  };
  hardware = {
    nvidia.enable = true;
    bluetooth.enable = true;
  };
  users.usr.enable = true;
  # boot.gummiboot.enable = true;
  boot.secure-boot.enable = true;

  nixpkgs.allowedUnfreePackages = [
    "spotify"
    "vscode"
    "obsidian"
    "discord"
  ];
}
