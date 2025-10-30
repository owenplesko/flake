{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [ ./waybar/waybar.nix ]; 
  
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
  ]; 

  programs.git = {
	  enable = true;
	  settings = {
		  user.name = "owen";
		  user.email = "owenplesko@gmail.com";
		  safe.directory = [ "/etc/nixos" ];
	  };
  };

  programs.zsh = {
    enable = true;
    initContent = ''
      neofetch
      eval "$(starship init zsh)"
    '';
  };

  programs.starship = {
    enable = true;
  };

  programs.kitty = {
	  enable = true;
          settings = {
	    shell = "${pkgs.zsh}/bin/zsh";
          };
  };

  wayland.windowManager.sway = {
	  enable = true; 
	  config = {
	          modifier = "Mod4";
		  terminal = "kitty";
		  bars = [ { command = "\${pkgs.waybar}/bin/waybar"; } ];
		  focus.followMouse = false;
		  startup = [
		    {command = "firefox";}
		    {command = "kitty";}
		  ];
		  gaps = {
			  inner = 8;
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
