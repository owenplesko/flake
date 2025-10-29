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
    settings = {
      "modules-right"  = [ "sway/workspaces" "sway/mode" ];
      "modules-center" = [ "clock" ];
      "modules-right"  = [ "network" "pulseaudio" "temperature" ];
      
      "clock" = {
        "format" = "{:%Y-%m-%d %H:%M:%S}"; 
      };
      
      "network" = {
        "format" = "{ifname}: {ipaddr}";
        "tooltip" = false;
      };

      "pulseaudio" = {
        "format" = "{volume}%";
      };
    };
  };
}
