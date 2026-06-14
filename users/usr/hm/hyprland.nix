{
  inputs,
  userConfig,
  hostConfig,
  lib,
  ...
}:

let
  lastChar =
    str: builtins.substring ((builtins.stringLength str) - 1) (builtins.stringLength str) str;

  luaValue = lib.generators.toLua { };
  luaInline = lib.generators.mkLuaInline;

  regularbinds = [
    "$mod SHIFT, Left, hy3:movewindow, l"
    "$mod SHIFT, Right, hy3:movewindow, r"
    "$mod SHIFT, Up, hy3:movewindow, u"
    "$mod SHIFT, Down, hy3:movewindow, d"
    "$mod, Left, hy3:movefocus, l"
    "$mod, Right, hy3:movefocus, r"
    "$mod, Up, hy3:movefocus, u"
    "$mod, Down, hy3:movefocus, d"
    "$mod, X, hy3:makegroup, h"
    "$mod SHIFT, X, hy3:makegroup, v"
    "$mod, F, exec, ${userConfig.programs.browser.pname}"
    "$mod, M, exit"
    "$mod, T, exec, ${userConfig.programs.terminal.pname}"
    "$mod, Q, killactive"
    "$mod, L, exec, noctalia msg session lock"
    "$mod, escape, exec, noctalia msg panel-toggle session"
    "ALT, space, exec, noctalia msg panel-toggle launcher"
    ", Print, exec, grimblast copy area"
    "$mod SHIFT, S, exec, grim -g \"$(slurp)\"  - | tee >(stash store) >(satty -f -)"
    "SUPER_SHIFT, C, exec, kitten panel --lines=20 --columns=100 --layer=overlay --edge=center-sized --focus-policy=on-demand -- stash list"
    ", F1, togglespecialworkspace, E"
  ]
  ++ (
    # workspaces
    # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
    builtins.concatLists (
      builtins.genList (x: [
        "$mod, ${lastChar (toString (x + 1))}, workspace, ${toString (x + 1)}"
        "$mod SHIFT, ${lastChar (toString (x + 1))}, movetoworkspace, ${toString (x + 1)}"
      ]) 10
    )
  );

  mkLuaBind =
    {
      keys,
      action,
      opts ? { },
    }:
    {
      _args = [
        (builtins.concatStringsSep " + " keys)
        (luaInline action)
        opts
      ];
    };

  mkKeys = v: v // { _type = "keys"; };
  mkBind =
    {
      action,
      opts ? { },
    }:
    {
      inherit action opts;
      _type = "bind";
    };

  mkExec = cmd: { action = "hl.dsp.exec_cmd(${luaValue cmd})"; };

  mkBindli =
    { action }:
    mkBind {
      inherit action;
      opts = {
        locked = true;
        ignore_mods = true;
      };
    };

  mkBindm =
    { action }:
    mkBind {
      inherit action;
      opts = {
        mouse = true;
      };
    };

  binds = {
    SUPER = mkKeys {
      SHIFT = mkKeys {
        Left = mkBind { action = "hy3.move_window(\"l\")"; };
        Right = mkBind { action = "hy3.move_window(\"r\")"; };
        Up = mkBind { action = "hy3.move_window(\"u\")"; };
        Down = mkBind { action = "hy3.move_window(\"d\")"; };
        X = mkBind { action = "hy3.make_group(\"v\")"; };

        S = mkBind (mkExec "grim -g \"$(slurp)\" - | tee >(stash store) >(satty -f -)");
        C = mkBind (
          mkExec "kitten panel --lines=20 --columns=100 --layer=overlay --edge=center-sized --focus-policy=on-demand -- stash list"
        );
      };
      Left = mkBind { action = "hy3.move_focus(\"l\")"; };
      Right = mkBind { action = "hy3.move_focus(\"r\")"; };
      Up = mkBind { action = "hy3.move_focus(\"u\")"; };
      Down = mkBind { action = "hy3.move_focus(\"d\")"; };
      X = mkBind { action = "hy3.make_group(\"h\")"; };

      J = mkBind { action = "hl.dsp.window.float(${luaValue { action = "toggle"; }})"; };
      K = mkBind { action = "hl.dsp.window.fullscreen(${luaValue { action = "toggle"; }})"; };

      F = mkBind (mkExec userConfig.programs.browser.pname);
      T = mkBind (mkExec userConfig.programs.terminal.pname);
      M = mkBind { action = "hl.dsp.exit()"; };
      Q = mkBind { action = "hl.dsp.window.close()"; };
      L = mkBind (mkExec "noctalia msg session lock");
      ESCAPE = mkBind (mkExec "noctalia msg panel-toggle session");

      "mouse:274" = mkBindm { action = "hl.dsp.window.drag()"; };
      "mouse:272" = mkBindm { action = "hl.dsp.window.resize()"; };
    };
    ALT = mkKeys {
      SPACE = mkBind (mkExec "noctalia msg panel-toggle launcher");
    };

    "code:122" = mkBindli (mkExec "pamixer -d 5");
    "code:123" = mkBindli (mkExec "pamixer -i 5");
    "code:173" = mkBindli (mkExec "playerctl previous");
    "code:171" = mkBindli (mkExec "playerctl next");
    "code:172" = mkBindli (mkExec "playerctl play-pause");
    F1 = mkBind { action = "hl.dsp.workspace.toggle_special(\"E\")"; };

  };

  processGroup =
    value:
    builtins.concatLists (
      builtins.attrValues (
        builtins.mapAttrs (
          name: value:
          if value._type == "keys" then
            map (
              {
                keys,
                action,
                opts,
              }:
              {
                inherit action opts;
                keys = [ name ] ++ keys;
              }
            ) (processGroup value)
          else
            assert value._type == "bind";
            [
              {
                keys = [ name ];
                inherit (value) action opts;
              }
            ]
        ) (removeAttrs value [ "_type" ])
      )
    );
  processedBinds = map mkLuaBind (processGroup binds);
  generatedBinds = builtins.concatLists (
    builtins.genList (x: [
      (mkLuaBind {
        keys = [
          "SUPER"
          "${lastChar (toString (x + 1))}"
        ];
        action = "hl.dsp.focus({workspace = ${toString (x + 1)}})";
      })
      (mkLuaBind {
        keys = [
          "SUPER"
          "SHIFT"
          "${lastChar (toString (x + 1))}"
        ];
        action = "hl.dsp.window.move({workspace = ${toString (x + 1)}})";
      })
    ]) 10
  );

  animate =
    leaf: speed: animation:
    animation
    // {
      inherit leaf speed;
      enabled = true;
    };
in
{
  wayland.windowManager.hyprland = {

    enable = hostConfig.desktops.hyprland.enable;

    package = hostConfig.pkgs.hyprland;
    # finalPackage = lib.mkForce null;
    portalPackage = null;

    plugins = [
      inputs.hy3.packages.x86_64-linux.hy3
    ];

    # conflicts with uwsm
    systemd.enable = false;

    configType = "lua";

    settings = {
      hy3 = {
        _var = luaInline "hl.plugin.hy3";
      };
      bind = processedBinds ++ generatedBinds;

      on = {
        _args = [
          "hyprland.start"
          (luaInline ''
            function()
            ${lib.concatMapStrings (command: "  hl.exec_cmd(${luaValue command})\n") [
              "stash watch"
              "hyprpaper"
              "noctalia --daemon"
              "wl-clip-persist -c both"
            ]}
            end
          '')
        ];
      };

      window_rule = [
        {
          match.title = "HELLDIVERS™ 2";
          fullscreen = true;
        }
        {
          match.title = "Titanfall 2";
          fullscreen = true;
        }
        {
          match.class = "vesktop";
          workspace = "special:E silent";
        }
        {
          match.class = "discord";
          workspace = "special:E silent";
        }
      ];

      config = {
        general = {
          layout = "hy3";
        };
        cursor = {
          no_hardware_cursors = false;
          use_cpu_buffer = true;
        };

        decoration = {
          rounding = 5;
          blur = {
            enabled = true;
            size = 5;
            passes = 1;
            vibrancy = 0.1696;
          };
        };

        input = {
          kb_options = "compose:ralt";
          kb_layout = "us";
          accel_profile = "flat";
        };
        debug.disable_logs = false;
      };

      curve = {
        _args = [
          ("bla")
          {
            type = "bezier";
            points = [
              [
                0.05
                0.9
              ]
              [
                0.1
                1.05
              ]
            ];
          }
        ];
      };

      animation = [
        (animate "windows" 5 { bezier = "bla"; })
        (animate "windowsOut" 5 {
          bezier = "default";
          style = "popin 80%";
        })
        (animate "border" 5 { bezier = "default"; })
        (animate "borderangle" 8 { bezier = "default"; })
        (animate "fade" 7 { bezier = "default"; })
        (animate "workspaces" 6 { bezier = "default"; })
        (animate "specialWorkspace" 3 {
          bezier = "default";
          style = "slidevert";
        })
      ];

      env = map (v: { _args = builtins.filter (x: x != [ ]) (builtins.split "," v); }) [
        "XDG_CACHE_DIR,/home/usr/.cache/"
        "XDG_CONFIG_HOME,/home/usr/.config/"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "NIXOS_OZONE_WL,1"
      ];

      monitor = {
        output = "Unknown-1";
        disabled = true;
      };
    };
  };
}
