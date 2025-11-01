{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: 
let
  profile = "owen";
in
{
  programs.firefox = {
    enable = true;
    
    profiles = {
      owen = {
	name = "${profile}";
	isDefault = true;	
        extensions = [ ]; 
      };
    };
  };

  stylix.targets.firefox.profileNames = [ "${profile}" ];
}
