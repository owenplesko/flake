{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
  ];

  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "owen";
    homeDirectory = "/home/owen";
  };

  home.packages = with pkgs; [
    vlc
    discord
    spotify
    neofetch
    pywal

    # Scripts
    (writeShellScriptBin "rebuild" ''
      #!${bash}/bin/bash
      sudo nixos-rebuild switch --flake /etc/nixos#nixos
    '')
    (writeShellScriptBin "nixos-edit" ''
      #!${bash}/bin/bash
      sudo nvim /etc/nixos
    '')
  ];

  programs.kitty = {
    enable = true;
    settings = {
      include = "~/.cache/wal/colors-kitty.conf";
    };
  };

  programs.firefox = {
    enable = true;
    
    profiles = {
      default = {
        id = 0;
	name = "default";
	isDefault = true;	
        extensions = [ ]; 
      };
    };
  }; 

  programs.git = {
    enable = true;
    userName = "owen";
    userEmail = "owenplesko@gmail.com";
    extraConfig = {
      safe.directory = [ "/etc/nixos" ];
    };
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
