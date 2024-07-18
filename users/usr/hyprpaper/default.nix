{inputs, ...}: {
  imports = [
    ./module.nix
  ];
  programs.hyprpaper = {
    enable = true;
    settings = {
      preload = [".config/hypr/hyprpapers/wallpaper.png"];
      wallpaper = ",.config/hypr/hyprpapers/wallpaper.png";
    };
    package = inputs.hyprpaper.packages."x86_64-linux".hyprpaper;

    wallpaperDir = ./wallpapers;
  };
}
