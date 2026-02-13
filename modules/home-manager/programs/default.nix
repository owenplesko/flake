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

  programs.lazydocker.enable = true;

  home.packages = with pkgs; [
    # secrets
    sops

    # media
    vlc
    spotify
    chromium
    discord

    # cli
    fastfetch

    # dev
    beekeeper-studio
    docker
    go
    zig
    python313
    nodejs_24
    gcc
    uv
    bun
    rustup

    # games
    prismlauncher
    gale

    # Scripts
    (writeShellScriptBin "rebuild" ''
      #!${bash}/bin/bash
      sudo nixos-rebuild switch --flake /etc/nixos#personal
    '')
  ];
}
