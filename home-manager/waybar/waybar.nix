{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : let
    configFile = builtins.readFile ./config.json;
    config = builtins.fromJSON configFile;
  in {
  stylix.targets.waybar.enable = false;
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [ config ];
    style = ./style.css;
  };
}
