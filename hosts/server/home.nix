{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home-manager/nvim
    ../../modules/home-manager/git
    ../../modules/home-manager/starship
    ../../modules/home-manager/zsh
    ../../modules/home-manager/kitty
  ];

  programs.home-manager.enable = true;

  home = {
    username = "owen";
    homeDirectory = "/home/owen";
    stateVersion = "23.05";
  };

  home.packages = with pkgs; [
    # secrets
    sops

    # cli
    fastfetch

    # dev
    docker

    # Scripts
    (writeShellScriptBin "rebuild" ''
      #!${bash}/bin/bash
      timestamp=$(date "+%Y-%m-%d %H:%M:%S")
      cd /home/owen/nixos
      git add .
      git commit -m "$timestamp $1"
      git push
      sudo nixos-rebuild switch --flake /home/owen/nixos#server
    '')
  ];
}
