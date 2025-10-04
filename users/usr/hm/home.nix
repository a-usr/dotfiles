{
  pkgs,
  inputs,
  ...
}:
{
  # imports = [
  #   ./playerctl
  #   ./hyprpaper
  #   ./ags
  #   ./zsh
  #   ./nushell
  #   ./starship
  #   ./hyprlock
  #   ./nvim
  # ];

  home.sessionVariables = {
    XDG_CONFIG_HOME = "~/.config/";
    EDITOR = "nvim";
  };

  programs = {
    tmux = {
      enable = true;
      # shortcut = "y";
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
    eza = {
      enable = true;
      enableNushellIntegration = false;
    };

    zoxide.enable = true;

  };
  home.stateVersion = "23.11";
}
