{ pkgs, home-manager, config, ...}:
let
  lastChar = str: builtins.substring ((builtins.stringLength str) -1) (builtins.stringLength str) str;
in
{

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      bind =
        [
          ", code:122, exec, pamixer -d 5"
          ", code:123, exec, pamixer -i 5"
          ", code:173, exec, playerctl previous"
          ", code:171, exec, playerctl next"
          ", code:172, exec, playerctl play-pause"
          "$mod, F, exec, firefox"
          ", Print, exec, grimblast copy area"
          "$mod, M, exit"
          "$mod, T, exec, alacritty"
          "$mod, Q, killactive"
          "ALT, space, exec, wofi --show=drun"
          "CTRL_SHIFT, S, exec, grim -g \"$(slurp)\"  - | tee >(wl-copy) >\"/home/usr/$(date +'%y%m%d_%Hh%Mm%Ss')_grim.png\""
          "SUPER_SHIFT, C, exec, cliphist list | wofi --show=dmenu | cliphist decode | wl-copy"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (
              x: [
                "$mod, ${lastChar (toString(x+1))}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${lastChar (toString (x+1))}, movetoworkspace, ${toString (x + 1)}"
              ]
            )
        10)
        );
    
      exec-once = [
        "hyprpaper"
        "eww open bar"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];

      decoration = {
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        
        animation = [
          "windows, 1, 5, myBezier"
          "windowsOut, 1, 5, default, popin 80%"
          "border, 1, 5, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      bindm = [
        "$mod, mouse:273, movewindow"
        "$mod, mouse:272, resizewindow"
      ];

      env = [
        "WLR_NO_HARDWARE_CURSORS,1"
      ];

      input = {
        kb_layout = "de";
      };

      monitor = "Unknown-1, disable";

    }; 
  };
}
