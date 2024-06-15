{ ... }:
{
  programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initExtra = ''
        vv() {
          # Assumes all configs exist in directories named ~/.config/nvim-*
          local config=$(print -lr -- ~/.config/nvim-*(:t:s/nvim-/) | fzf --prompt="Neovim Configs > " --height=~50% --layout=reverse --border --exit-0)
 
          # If I exit fzf without selecting a config, don't open Neovim
          [[ -z $config ]] && echo "No config selected" && return
 
          # Open Neovim with the selected config
          NVIM_APPNAME=$(basename ~/.config/nvim-$config) nvim $@
        }
      '';
    };
}
