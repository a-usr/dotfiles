{ pkgs, ... }:
{
  programs.eww = {
    enable = true;
    configDir = "/home/usr/config/eww";
  };
}