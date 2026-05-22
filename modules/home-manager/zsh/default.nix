{...}: {
  programs.zsh = {
    enable = true;
    initContent = ''
      fastfetch
      eval "$(starship init zsh)"
    '';
  };
}
