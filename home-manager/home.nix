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

  stylix.image = ../assets/background/pixel_galaxy.png;

  programs.git = {
	  enable = true;
	  settings = {
		  user.name = "owen";
		  user.email = "owenplesko@gmail.com";
		  safe.directory = [ "/etc/nixos" ];
	  };
  };

  programs.kitty = {
	  enable = true;
	  settings = {
	  };
  };

  programs.waybar = {
	  enable = true;
	  systemd.enable = true;
  };

  wayland.windowManager.sway = {
	  enable = true; 
	  config = {
	          modifier = "Mod4";
		  bars = [ { command = "\${pkgs.waybar}/bin/waybar"; } ];
		  focus.followMouse = false;
		  startup = [
		    {command = "firefox";}
		    {command = "kitty";}
		  ];
		  gaps = {
			  inner = 20;
		  };
	  };
    systemd = {
      enable = true;
      variables = ["--all"];
    };
    wrapperFeatures.gtk = true;
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
