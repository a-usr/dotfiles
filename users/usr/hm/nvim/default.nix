{ pkgs, hostConfig, ... }:
{
  programs.neovim = {
    # package = pkgs.neovim-unwrapped;
    enable = true;
    defaultEditor = true;
    withPython3 = false;
    withRuby = false;
    waylandSupport = hostConfig.internal.graphical;
    extraPackages = with pkgs; [
      chafa
      neovim-remote
      lua

      # Language Servers
      nixd
      nil
      bash-language-server
      emmylua-ls
      # zls

      typescript
      # nodePackages_latest.typescript-language-server
      vscode-langservers-extracted

      # Formatter
      # python311Packages.black # Python formatter
      clang-tools
      # nodePackages_latest.prettier # JSON, JS, TS formatter
      yamlfmt # YAML formatter
      taplo # TOML formatter
      shfmt # Shell, Bash etc.
      nixfmt
      stylua # lua formatter

      # Misc
      lazygit
      tree-sitter
    ];

  };
}
