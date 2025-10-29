{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [ builtins.fromJSON builtins.readFile ./config.json ];
  };
}
