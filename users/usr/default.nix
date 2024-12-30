{
  pkgs,
  ...
}:
{
  imports =
    [
    ];

  users.users.usr = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "localhost"
      "scanner"
      "lp"
    ]; # Enable ‘sudo’ for the user.
    shell = pkgs.nushell;
  };
  home-manager.users.usr = import ./home.nix;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
    extraPackages = with pkgs; [
      libgdiplus
      keyutils
      libkrb5
      libpng
      libpulseaudio
      libvorbis
      stdenv.cc.cc.lib
      xorg.libXcursor
      xorg.libXi
      xorg.libXinerama
      xorg.libXScrnSaver
    ];
  };
  programs.gamescope = {
    enable = true;
    package = pkgs.gamescope;
  };
}
