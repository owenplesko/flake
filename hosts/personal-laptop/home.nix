{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home-manager/programs/nvim
  ];

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    nodejs_24
    bun

    # Scripts
    (writeShellScriptBin "rebuild" ''
      #!${bash}/bin/bash
      sudo darwin-rebuild switch --flake .#Owens-MacBook
    '')
  ];

  home = {
    username = "owen";
    stateVersion = "23.05";
  };
}
