{pkgs, ...}: {
  imports = [
    ../../modules/home-manager/nvim
  ];

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    nodejs_24
    bun

    # Scripts
    (writeShellScriptBin "rebuild" ''
      #!${bash}/bin/bash
      timestamp=$(date "+%Y-%m-%d %H:%M:%S")
      cd ~/nixos
      git add .
      git commit -m "$timestamp $1"
      git push
      sudo darwin-rebuild switch --flake .#Owens-MacBook
    '')
  ];

  home = {
    username = "owen";
    stateVersion = "23.05";
  };
}
