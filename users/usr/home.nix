{
  configs,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./playerctl
    ./hyprland
    ./hyprpaper
    ./ags
    ./gtk
    ./alacritty
    ./foot
    ./zsh
    ./starship
    ./hyprlock
    ./nixvim
    ./helix
  ];

  home.sessionVariables = {
    XDG_CONFIG_HOME = "~/.config/";
  };

  home.packages = with pkgs; [
    starship
    tmux
    chromium
    grimblast
    alacritty
    #webcord-vencord
    vesktop
    (nerdfonts.override {fonts = ["Hermit" "CascadiaCode"];})
    #spicetify-cli

    xfce.thunar
    nordic

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

    prismlauncher
    #jdk
    #jdk17
    #jdk8

    dart-sass
    sassc
    bun
    libnotify

    papirus-icon-theme
    gnome3.adwaita-icon-theme

    ncspot
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
  };
  home.stateVersion = "23.11";
}
