{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : {
  programs.firefox = {
    enable = true;
    
    profiles = {
      default = {
	id = 0;
	name = "default";
	isDefault = true;	
        settings = {
	  "browser.startup.homepage" = "https://google.com";
	};
	extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
	];
	bookarks = [
          {
	    name = "Nix Resources";
	    bookmarks = [
	      {
	        name = "Home Manager";
		url = "https://nix-community.github.io/home-manager/options.xhtml";
	      }
	      {
	        name = "Stylix";
		url = "https://nix-community.github.io/stylix/";
	      }
	    ];
	  }
	];
      };
    };
  };

  stylix.targets.firefox.profileNames = [ "default" ];
}
