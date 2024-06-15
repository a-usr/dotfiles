{ home-manager, lib, pkgs, ... }:
{
  imports = [ 
   
  ];
  users.users.usr = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "localhost" ];# Enable ‘sudo’ for the user.
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

  };
  programs.gamescope = {
    enable = true;
    package = pkgs.unstable.gamescope;
  };
}
