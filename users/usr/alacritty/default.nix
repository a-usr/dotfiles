{...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.65;
      };
      font = {
        normal = {
          family = "CaskaydiaCove Nerd Font Mono";
          style = "Regular";
        };
      };
    };
  };
}
