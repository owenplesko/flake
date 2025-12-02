{...}: let
  declareWorkspaces = n:
    if n > 0
    then
      declareWorkspaces (n - 1)
      ++ [
        "$mod, ${toString n}, workspace, ${toString n}"
        "$mod SHIFT, ${toString n}, movetoworkspace, ${toString n}"
      ]
    else [];
in {
  services.hypridle = {
    enable = true;
    settings = {
      listener = [
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on && brightnessctl -r"; # screen on when activity is detected after timeout has fired.
        }
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";

      # mouse movements
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];

      bind =
        [
          # window management
          "$mod, Q, killactive"
          "$mod, F, fullscreen"

          # move focus
          "$mod, LEFT, movefocus, l"
          "$mod, RIGHT, movefocus, r"
          "$mod, UP, movefocus, u"
          "$mod, DOWN, movefocus, d"

          # applications
          "$mod, SPACE, exec, wofi --show drun"
          "$mod, RETURN, exec, kitty"
        ]
        ++ declareWorkspaces 9;

      monitor = [
        "DP-1,3440x1440@174.96Hz,0x0,1"
      ];

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 1;

        allow_tearing = true;
        resize_on_border = true;
      };

      decoration = {
        rounding = 10;
        rounding_power = 2.5;
        blur = {
          enabled = true;
          brightness = 1.0;
          contrast = 1.0;
          noise = 0.01;

          vibrancy = 0.2;
          vibrancy_darkness = 0.5;

          passes = 4;
          size = 7;

          popups = true;
          popups_ignorealpha = 0.2;
        };

        shadow = {
          enabled = true;
          ignore_window = true;
          offset = "0 15";
          range = 100;
          render_power = 2;
          scale = 0.97;
        };
      };

      animations.enabled = false;

      group = {
        groupbar = {
          font_size = 10;
          gradients = false;
        };
      };
    };
  };
}
