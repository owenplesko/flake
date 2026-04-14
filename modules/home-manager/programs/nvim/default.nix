{pkgs, ...}: {
  home.packages = with pkgs; [
    # required programs
    ripgrep

    # language servers
    nil
    lua-language-server
    gopls
    typescript-language-server
    tailwindcss-language-server
    pyright
    zls

    # formatters
    alejandra
    stylua
    gofumpt
    gotools
    prettierd
  ];

  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      mini-nvim
      neo-tree-nvim
      telescope-nvim
      telescope-fzf-native-nvim
      render-markdown-nvim
      tailwind-tools-nvim
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
