{
  ...
}:
{
  programs.hyprlock = {
    enable = true;
    settings = {
      "background" = {
        monitor = "";
        path = "~/.config/hypr/hyprpapers/AE86Trueno.jpg";
        blur_passes = 1;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      };

      "input-field" = {
        monitor = "";
        size = "250, 60";
        outline_thickness = 2;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = "rgba(0, 0, 0, 0.5)";
        font_color = "rgb(200, 200, 200)";
        fade_on_empty = false;
        #font_family = "JetBrains Mono Nerd Font Mono";
        placeholder_text = "<i><span foreground=\"##cdd6f4\">Input Password...</span></i>";
        hide_input = false;
        position = "0, -120";
        halign = "center";
        valign = "center";
      };
      label = [
        {
          monitor = "";
          text = "$TIME";
          #color = "$foreground";
          color = "rgba(255, 255, 255, 0.6)";
          font_size = 120;
          #font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
          position = "0, -300";
          halign = "center";
          valign = "top";
        }
        {
          monitor = "";
          text = "Hi there, $USER";
          #color = "$foreground";
          color = "rgba(255, 255, 255, 0.6)";
          font_size = 25;
          #font_family = "JetBrains Mono Nerd Font Mono";
          position = "0, -40";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
