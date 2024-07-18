{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.hyprpaper;
in {
  options.programs.hyprpaper = {
    enable =
      mkEnableOption ""
      // {
        description = ''
          Whether to enable Hyprlock, Hyprland's GPU-accelerated lock screen
          utility.

          Note that PAM must be configured to enable hyprlock to perform
          authentication. The package installed through home-manager will *not* be
          able to unlock the session without this configuration.

          On NixOS, it can be enabled using:

          ```nix
          security.pam.services.hyprlock = {};
          ```
        '';
      };

    package = mkPackageOption pkgs "hyprpaper" {};

    settings = lib.mkOption {
      type = with lib.types; let
        valueType =
          nullOr (oneOf [
            bool
            int
            float
            str
            path
            (attrsOf valueType)
            (listOf valueType)
          ])
          // {
            description = "Hyprlock configuration value";
          };
      in
        valueType;
      default = {};
      example = lib.literalExpression ''
        #preload images
        preload = [ "/path/to/image.png" "path/to/next_image.png" ];
        #set the default wallpaper(s) seen on initial workspace(s) --depending on the number of monitors used
        wallpaper = [ "monitor1,/path/to/image.png"  "monitor2,/path/to/next_image.png" ];

        #enable splash text rendering over the wallpaper
        splash = true;

        #fully disable ipc
        # ipc = "off";
      '';
      description = ''
        Hyprpaper configuration written in Nix. Entries with the same key should
        be written as lists. Variables' and colors' names should be quoted. See
        <https://wiki.hyprland.org/Hypr-Ecosystem/hyprpaper/> for more examples.
      '';
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra configuration lines to add to `~/.config/hypr/hyprpaper.conf`.
      '';
    };

    sourceFirst =
      lib.mkEnableOption ''
        putting source entries at the top of the configuration
      ''
      // {
        default = true;
      };

    importantPrefixes = lib.mkOption {
      type = with lib.types; listOf str;
      default =
        []
        ++ lib.optionals cfg.sourceFirst ["source"];
      example = ["$" "monitor" "size"];
      description = ''
        List of prefix of attributes to source at the top of the config.
      '';
    };
    wallpaperDir = lib.mkOption {
      type = types.path;
      example = literalExpression "./wallpapers";
      description = ''
        The directory that gets linked to {file} `$XDG_CONFIG_HOME\hypr\hyprpapers`.
        Should contain wallpapers to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];
    xdg.configFile."hypr/hyprpapers".source = cfg.wallpaperDir;
    xdg.configFile."hypr/hyprpaper.conf" = let
      shouldGenerate = cfg.extraConfig != "" || cfg.settings != {};
    in
      mkIf shouldGenerate {
        text =
          lib.optionalString (cfg.settings != {})
          (lib.hm.generators.toHyprconf {
            attrs = cfg.settings;
            inherit (cfg) importantPrefixes;
          })
          + lib.optionalString (cfg.extraConfig != null) cfg.extraConfig;
      };
  };
}
