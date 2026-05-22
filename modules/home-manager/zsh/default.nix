{...}: {
  programs.zsh = {
    enable = true;
    initContent = ''
      fastfetch
      eval "$(starship init zsh)"
    '';
    loginShellInit = ''
      export PATH="$HOME/.cargo/bin:$PATH"
    '';
  };
}
