{ pkgs, ... }:
{
  programs.neovim = {
    # package = pkgs.neovim-unwrapped;
    enable = false;
    # defaultEditor = true;
    # withPython3 = false;
    # withRuby = false;
    extraPackages = with pkgs; [
    ];

  };
}
