{
  inputs,
  lib,
  config,
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
    ];

    extraLuaConfig = ''
      ${builtins.readFile ./keymaps.lua}
    '';
  };
}
