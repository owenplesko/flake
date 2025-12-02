{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home-manager/programs
    ../../modules/home-manager/ui
  ];

  nixpkgs = {
    overlays = [inputs.nur.overlays.default];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = [
        "beekeeper-studio-5.3.4"
      ];
    };
  };

  programs.home-manager.enable = true;

  # cursor
  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    hyprcursor.enable = true;
  };

  home = {
    username = "owen";
    homeDirectory = "/home/owen";
    stateVersion = "23.05";
  };

  home.packages = with pkgs; [
    vlc
    spotify
    fastfetch
    prismlauncher
    beekeeper-studio
    nemo
    docker
    go
    python313
    nodejs_24
    gcc
    uv
    moonlight-qt

    # Scripts
    (writeShellScriptBin "rebuild" ''
      #!${bash}/bin/bash
      sudo nixos-rebuild switch --flake /etc/nixos#personal
    '')
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "owen";
      user.email = "owenplesko@gmail.com";
      safe.directory = ["/etc/nixos"];
    };
  };

  programs.zsh = {
    enable = true;
    initContent = ''
      fastfetch
      eval "$(starship init zsh)"
    '';
  };

  programs.starship = {
    enable = true;
  };

  programs.lazydocker.enable = true;

  programs.kitty = {
    enable = true;
    settings = {
      shell = "${pkgs.zsh}/bin/zsh";
    };
  };

  programs.vesktop.enable = true;

  home.sessionVariables = {
    FILE_MANAGER = "nemo";
    XDG_FILE_MANAGER = "nemo";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
