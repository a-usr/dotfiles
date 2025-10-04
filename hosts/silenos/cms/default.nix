{
  desktops.hyprland.enable = true;
  extra = {
    v4l2loopback.enable = true;
    gaming.steam = true;
  };
  hardware.nvidia.enable = true;
  users.usr.enable = true;

  nixpkgs.allowedUnfreePackages = [
    "spotify"
    "vscode"
    "obsidian"
  ];
}
