{configs, lib, pkgs, ...}: 
{
  imports = [
    ./playerctl
    ./hyprland
    ./eww
    ./hyprpaper
  ];
  home.packages = with pkgs; [
    rustup
    starship
    tmux
    firefox
    grimblast
    alacritty
    armcord
    (nerdfonts.override { fonts = ["Hermit" "CascadiaCode"]; })
    rPackages.phosphoricons
    hyprpaper
    spicetify-cli
    grim
    slurp
  ];
  programs = {
      
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };

    starship = {
      enable = true;
    };
    tmux = {
      enable = true;
      shortcut = "y";
      extraConfig = ''
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
      enable = true;
    };
  };
  home.stateVersion = "23.11";
}

