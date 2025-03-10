{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./playerctl
    ./hyprland
    ./hyprpaper
    ./ags
    ./gtk
    ./alacritty
    ./zsh
    ./nushell
    ./starship
    ./hyprlock
    ./nvim
  ];

  home.sessionVariables = {
    XDG_CONFIG_HOME = "~/.config/";
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    starship
    tmux
    chromium
    grimblast
    alacritty
    #webcord-vencord
    vesktop
    nerd-fonts.hurmit
    nerd-fonts.caskaydia-mono
    nerd-fonts.caskaydia-cove
    #spicetify-cli

    xfce.thunar
    yazi
    everforest-gtk-theme

    grim
    slurp
    wayshot
    inputs.hyprpicker.packages."x86_64-linux".hyprpicker
    swappy

    brightnessctl
    gvfs

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
    rmpc
    bottom

    wine
    rare
    legendary-gl
    #inputs.nixGaming.packages.x86_64-linux.viper

    flatpak # I hate myself for this

    wf-recorder
    obs-studio
    pwvucontrol
    easyeffects
    qpwgraph
    obsidian

    wezterm
  ];
  programs = {
    tmux = {
      enable = true;
      shortcut = "y";
      extraConfig = ''
        set -g mouse on
        bind , split-window -h
        bind . split-window -v
      '';
    };

    wofi = {
      enable = true;
      style = ''
               window {
        margin: 5px;
        padding: 5px;
        background-color:  #434c5e;
        }

        #input {
        background-color:  #434c5e;
        color: #eceff4;
        border: 0px solid  #434c5e;
        }

        #input:focus {
        background-color: #5e81ac;
        color: #eceff4;
        border: 0px solid   #434c5e;
        }

        #inner-box {
        background-color:  #434c5e;
        }

        #inner-box flowboxchild:focus {
        background-color: #5e81ac;
        }

        #outer-box {
        background-color:  #434c5e;
        }

        #scroll {
        background-color: #434c5e;
        }

        #text {
        margin: 2px;
        background-color: rgba(0,0,0,0);
        color: #eceff4;
        }
      '';
    };

    waybar = {
      enable = false;
    };
    direnv = {
      enable = true;
    };
    eza.enable = true;

    zoxide.enable = true;

  };
  home.stateVersion = "23.11";
}
