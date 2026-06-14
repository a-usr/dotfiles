{ pkgs, hostConfig, ... }:
{
  rum.misc.gtk = {
    enable = hostConfig.internal.graphical;
    packages = with pkgs; [
      papirus-icon-theme
      gnome-themes-extra
    ];
    settings = {
      theme-name = "Adwaita";
      icon-theme-name = "Papirus";
      application-prefer-dark-theme = true;
      # interface-color-scheme = 2;
    };

  };
}
