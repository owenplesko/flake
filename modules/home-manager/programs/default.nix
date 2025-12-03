{pkgs, ...}: {
  imports = [
    ./firefox
    ./nvim
    ./git
    ./starship
    ./zsh
    ./kitty
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "beekeeper-studio-5.3.4"
      ];
    };
  };

  programs.vesktop.enable = true;
  programs.lazydocker.enable = true;

  home.packages = with pkgs; [
    # media
    vlc
    spotify

    # cli
    fastfetch

    # dev
    beekeeper-studio
    docker
    go
    python313
    nodejs_24
    gcc
    uv

    # games
    prismlauncher

    # Scripts
    (writeShellScriptBin "rebuild" ''
      #!${bash}/bin/bash
      sudo nixos-rebuild switch --flake /etc/nixos#personal
    '')
  ];
}
