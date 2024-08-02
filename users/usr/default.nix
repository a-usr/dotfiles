{
  home-manager,
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
  ];

  #filesystems."${config.users.users.usr.home}" = {
  #  device = "${lib.file.mkOutOfStoreSymlink ./.}";
  #  options = [
  #    "bind"
  #  ];
  #
  #};

  users.users.usr = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "localhost" "scanner" "lp"]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };
  home-manager.users.usr = import ./home.nix;

  programs.zsh.enable = true;
  #nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #  "steam"
  #  "steam-original"
  #  "steam-run"
  #];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
    extraPackages = with pkgs; [libgdiplus keyutils libkrb5 libpng libpulseaudio libvorbis stdenv.cc.cc.lib xorg.libXcursor xorg.libXi xorg.libXinerama xorg.libXScrnSaver];
  };
  programs.gamescope = {
    enable = true;
    package = pkgs.unstable.gamescope;
  };
}
