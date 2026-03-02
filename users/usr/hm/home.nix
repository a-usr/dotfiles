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
