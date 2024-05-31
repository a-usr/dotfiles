{ ... }:
{
  imports = [
    ./module.nix
  ];
  programs.hyprpaper = {
    enable = true;
    settings = {
      preload = [ ".config/hypr/hyprpapers/wallpaper.png" ]; 
      wallpaper = ",.config/hypr/hyprpapers/wallpaper.png";
    };

    wallpaperDir = ./wallpapers;
  };
}
