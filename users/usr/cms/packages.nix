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
      { pkgs, ... }:

      let
        neovim = inputs.mnw.lib.wrap pkgs {
          appName = "nvim";
          initLua = ''
            require('nvim')
          '';
          plugins.dev = {
            myconfig = {
              pure = ./nvim;
              impure = "/home/usr/.config/nvim";
            };
          };
          extraBinPath = with pkgs; [
            chafa
            neovim-remote
            lua

            # Language Servers
            rust-analyzer
            nixd
            nil
            pyright
            bash-language-server
            lua-language-server
            fish-lsp
            # zls

            typescript
            nodePackages_latest.typescript-language-server
            vscode-langservers-extracted

            # Formatter
            # python311Packages.black # Python formatter
            clang-tools
            nodePackages_latest.prettier # JSON, JS, TS formatter
            yamlfmt # YAML formatter
            taplo # TOML formatter
            rustfmt # Rust formatter
            shfmt # Shell, Bash etc.
            nixfmt-rfc-style
            stylua # lua formatter

            # Misc
            lazygit
            clang
            tree-sitter
          ];
        };
      in
      {
        packages = [
          inputs.noctalia.packages."${hostConfig.system}".default

          # neovim.devMode
        ]
        ++ (with pkgs; [
          nh
          jujutsu

          starship
          tmux
          grimblast
          #webcord-vencord
          (discord.override {
            withVencord = true;
            withOpenASAR = true;
          })
          nerd-fonts.hurmit
          nerd-fonts.caskaydia-mono
          nerd-fonts.caskaydia-cove
          #spicetify-cli

          yazi
          everforest-gtk-theme

          grim
          slurp
          wayshot
          inputs.hyprpicker.packages."x86_64-linux".hyprpicker
          satty

          brightnessctl

          alejandra

          imagemagick
          ffmpeg
          zip
          unzip

          fd
          fzf
          ripgrep
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
          bottom
          #inputs.nixGaming.packages.x86_64-linux.viper

          flatpak # I hate myself for this

          wf-recorder
          obs-studio
          pwvucontrol
          easyeffects
          qpwgraph
          obsidian

          lutris
        ]);
      }
    )
  ];
}
