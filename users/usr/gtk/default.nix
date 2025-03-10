{ pkgs, ... }:
{
  gtk = {
    enable = true;
    theme = {
      package = pkgs.everforest-gtk-theme;
      name = "Everforest-Dark";
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };
  };
}
