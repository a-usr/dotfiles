{ pkgs, ... }:
{
  rum.misc.gtk = {
    enable = true;
    packages = with pkgs; [
      everforest-gtk-theme
      papirus-icon-theme
    ];
    settings = {
      theme-name = "Everforest-Dark-BL-LB";
      icon-theme-name = "Papirus";
    };

  };
}
