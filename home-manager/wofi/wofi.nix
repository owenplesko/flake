{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : {
  programs.wofi = {
    enable = true;
  }; 
}
