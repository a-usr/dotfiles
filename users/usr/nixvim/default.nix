{inputs, ...}: {
  imports = [inputs.nixvim.homeManagerModules.nixvim];

  programs.nixvim = {
    enable = true;
    #defaultEditor = true;

    clipboard.providers.wl-copy.enable = true;
    colorschemes.nord.enable = true;
    plugins = {
      #languages
      treesitter.enable = true;
      nix.enable = true;
      nix-develop.enable = true;
      rustaceanvim.enable = true;

      oil.enable = true;
      alpha = {
        enable = true;
        theme = "dashboard";
      };
      telescope.enable = true;
      lualine = {
        enable = true;
        sectionSeparators = {
          left = "";
          right = "";
        };
      };
      ccc.enable = true;
      crates-nvim.enable = true;
      dap.enable = true;
      octo.enable = true;
    };
  };
}
