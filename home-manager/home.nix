{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [ ]; 
  
  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  programs.home-manager.enable = true; 

  home = {
    username = "owen";
    homeDirectory = "/home/owen";
    stateVersion = "23.05";
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

  programs.git = {
    enable = true;
    userName = "owen";
    userEmail = "owenplesko@gmail.com";
    extraConfig = {
      safe.directory = [ "/etc/nixos" ];
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      include = "~/.cache/wal/colors-kitty.conf";
    };
  };

  programs.waybar = {
    enable = true;
  };

  wayland.windowManager.sway = {
    enable = true;
    config = {
      bars = [ { command = "\${pkgs.waybar}/bin/waybar"; } ];
      focus.followMouse = false;
      gaps = {
        inner = 20;
      };
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
 
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
