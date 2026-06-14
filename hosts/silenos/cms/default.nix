{
  desktops.hyprland.enable = true;
  extra = {
    # v4l2loopback.enable = true; # BROKEN
    gaming.steam = true;
    daw.enable = true;
  };
  hardware = {
    nvidia.enable = true;
    bluetooth.enable = true;
  };
  users.usr = {
    enable = true;
    trustedUser = true;
    groups = [ "audio" ];
  };

  services.kdeconnect.enable = true;

  boot.gummiboot.enable = true;
  boot.secure-boot.enable = true;
  boot.canHasNtfs = true;

  nixpkgs.allowedUnfreePackages = [
    "spotify"
    "vscode"
    "obsidian"
    "discord"
    "discord-unwrapped"
    "epson_201207w"
    "iscan"
    "iscan-ds"
    "iscan-data"
    "iscan-nt-bundle"
    "iscan-network-nt"
    "wootility"
  ];
}
