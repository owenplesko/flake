{
  lib,
  config,
  pkgs,
  ...
}: let
  modifier = "Mod4";
in {
  wayland.windowManager.sway = {
    enable = true;
    config = {
      inherit modifier;
      output."DP-1".mode = "3440x1440@174.962Hz";
      terminal = "kitty";
      keybindings = lib.mkOptionDefault {
        "${config.wayland.windowManager.sway.config.modifier}+space" = "exec ${pkgs.wofi}/bin/wofi --show drun";
        "${config.wayland.windowManager.sway.config.modifier}+d" = "nop";
      };
      bars = [{command = "\${pkgs.waybar}/bin/waybar";}];
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

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 60;
        command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
      }
    ];
  };
}
