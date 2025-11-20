{pkgs, ...}: {
  home.packages = with pkgs; [
    ripgrep
    nil
    alejandra
    lua-language-server
    stylua
    gopls
    gofumpt
    typescript
    typescript-language-server
    prettierd
  ];

  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      mini-nvim
      telescope-nvim
      neo-tree-nvim
      telescope-fzf-native-nvim
      render-markdown-nvim
      blink-cmp
      conform-nvim
      nvim-treesitter
      (nvim-treesitter.withPlugins (p: [
        p.tree-sitter-nix
        p.tree-sitter-bash
        p.tree-sitter-lua
        p.tree-sitter-sql
        p.tree-sitter-json
        p.tree-sitter-yaml
        p.tree-sitter-python
        p.tree-sitter-go
        p.tree-sitter-typescript
        p.tree-sitter-javascript
      ]))
    ];

    extraLuaConfig = ''
      ${builtins.readFile ./keymaps.lua}
      ${builtins.readFile ./settings.lua}
      ${builtins.readFile ./lsp.lua}
    '';
  };
}
