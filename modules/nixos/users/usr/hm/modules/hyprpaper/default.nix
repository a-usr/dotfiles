{ inputs, ... }:
{
  imports = [
    ./module.nix
  ];
  programs.hyprpaper = {
    enable = true;
    settings = {
      preload = [ ".config/hypr/hyprpapers/AE86Trueno.jpg" ];
      wallpaper = ",.config/hypr/hyprpapers/AE86Trueno.jpg";
    };
    package = inputs.hyprpaper.packages."x86_64-linux".hyprpaper;

    wallpaperDir = ./wallpapers;
  };
}
