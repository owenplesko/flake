{
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      mini-nvim

      telescope-nvim
      telescope-fzf-native-nvim

      nvim-lspconfig
      nvim-cmp

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
