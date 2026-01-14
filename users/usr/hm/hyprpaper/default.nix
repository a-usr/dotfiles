{ inputs, ... }:
{
  imports = [
    ./module.nix
  ];
  programs.hyprpaper = {
    enable = true;
    settings = {
      wallpaper = {
        monitor = "";
        path = ".config/hypr/hyprpapers/AE86Trueno.jpg";
      };
    };
    package = inputs.hyprpaper.packages."x86_64-linux".hyprpaper;

    wallpaperDir = ./wallpapers;
  };
}
