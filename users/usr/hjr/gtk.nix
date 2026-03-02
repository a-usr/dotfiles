{ pkgs, hostConfig, ... }:
{
  rum.misc.gtk = {
    enable = hostConfig.internal.graphical;
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
