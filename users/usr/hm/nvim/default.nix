{ pkgs, ... }:
{
  programs.neovim = {
    # package = pkgs.neovim-unwrapped;
    enable = true;
    defaultEditor = true;
    withPython3 = false;
    withRuby = false;
    extraPackages = with pkgs; [
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
}
