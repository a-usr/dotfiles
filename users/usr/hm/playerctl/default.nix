{ pkgs, hostConfig, ... }:
{
  home.packages = with pkgs; [ playerctl ];
  services.playerctld = {
    enable = hostConfig.general.sound;
  };
}
