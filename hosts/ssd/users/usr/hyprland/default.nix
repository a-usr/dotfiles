{ pkgs, home-manager, config, inputs, ...}:
let
  lastChar = str: builtins.substring ((builtins.stringLength str) -1) (builtins.stringLength str) str;
in
{
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  wayland.windowManager.hyprland = {
    #package = pkgs.trunk.hyprland;
    enable = true;
    settings = {
      "$mod" = "SUPER";
      bind =
        [
          "$mod, escape, exec, ags --toggle-window powermenu"
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
          "$mod SHIFT, S, exec, grim -g \"$(slurp)\"  - | tee >(wl-copy) >(swappy -f -)"
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
        )
        ++ [
          ", F1, togglespecialworkspace, E"
        ];
    
      exec-once = [
        "hyprpaper"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "ags"
      ];

      windowrulev2 = [
        
      ];

      decoration = {
        rounding = 5;
        blur = {
          enabled = true;
          size = 5;
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
        "$mod, mouse:274, movewindow"
        "$mod, mouse:272, resizewindow"
      ];

      env = [
        "XDG_CACHE_DIR,/home/usr/.cache/"
        "XDG_CONFIG_HOME,/home/usr/.config/"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        #"NIXOS_OZONE_WL,1"
      ];
      input = {
        kb_layout = "de";
      };

      monitor = "Unknown-1, disable";

    }; 
  };
}
