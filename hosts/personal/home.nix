{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home-manager/firefox
    ../../modules/home-manager/nvim
    ../../modules/home-manager/git
    ../../modules/home-manager/starship
    ../../modules/home-manager/zsh
    ../../modules/home-manager/kitty
    inputs.sops-nix.homeManagerModules.sops
  ];

  programs.home-manager.enable = true;

  home = {
    username = "owen";
    homeDirectory = "/home/owen";
    stateVersion = "23.05";
  };

  # silence warning
  gtk.gtk4.theme = config.gtk.theme;

  nixpkgs = {
    overlays = [inputs.nur.overlays.default];
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "beekeeper-studio-5.3.4"
      ];
    };
  };

  sops = {
    age.keyFile = "/etc/sops/age/keys.txt";
  };

  home.packages = with pkgs; [
    # media
    vlc
    spotify
    chromium
    discord

    # cli
    fastfetch
    sops

    # rdp client
    remmina

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
      timestamp=$(date "+%Y-%m-%d %H:%M:%S")
      cd ~/nixos
      git add .
      git commit -m "$timestamp $1"
      git push
      sudo nixos-rebuild switch --flake /etc/nixos#personal
    '')
  ];

  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];
}
