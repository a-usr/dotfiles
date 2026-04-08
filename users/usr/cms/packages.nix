{ inputs, hostConfig, ... }:
{

  programs = {
    browser = inputs.zen-browser.packages."${hostConfig.system}".default.override {
      extraPrefsFiles = [
        (builtins.fetchurl {
          url = "https://raw.githubusercontent.com/MrOtherGuy/fx-autoconfig/master/program/config.js";
          sha256 = "1mx679fbc4d9x4bnqajqx5a95y1lfasvf90pbqkh9sm3ch945p40";
        })
      ];
    };
    terminal = hostConfig.pkgs.kitty;
  };

  userModule.imports = [
    (
      { pkgs, lib, ... }:

      let
        inherit (lib.lists) optionals;

      in
      {
        packages = (
          with pkgs;
          [

            nh
            jujutsu
            git

            starship
            tmux
            #spicetify-cli
            zip
            unzip

            fd
            fzf
            ripgrep
            bottom
          ]
          ++ optionals (hostConfig.internal.graphical) [
            inputs.noctalia.packages."${hostConfig.system}".default

            yazi
            #webcord-vencord
            (discord.override {
              withVencord = true;
              withOpenASAR = true;
            })

            everforest-gtk-theme

            grim
            slurp
            wayshot
            inputs.hyprpicker.packages."x86_64-linux".hyprpicker
            satty

            brightnessctl
            wl-clip-persist
            imagemagick

            nerd-fonts.hurmit
            nerd-fonts.caskaydia-mono
            nerd-fonts.caskaydia-cove
            ffmpeg
            # (
            #     pkgs.emacsWithPackagesFromPackageRequires {
            #         packageElisp = "";
            #         package = pkgs.emacs-pgtk;
            #         extraEmacsPackages = epkgs: [
            #             pkgs.ispell
            #         ];
            #     }
            # )
            (prismlauncher.override {
              jdks = [
                pkgs.jdk21
                pkgs.jdk17
                pkgs.jdk8
              ];
            })
            #jdk
            #jdk17
            #jdk8

            dart-sass
            sassc
            bun
            libnotify

            papirus-icon-theme
            adwaita-icon-theme

            ncspot
            #inputs.nixGaming.packages.x86_64-linux.viper

            flatpak # I hate myself for this

            wf-recorder
            obs-studio
            pwvucontrol
            easyeffects
            qpwgraph
            obsidian

            lutris
          ]
        );
      }
    )
  ];
}
