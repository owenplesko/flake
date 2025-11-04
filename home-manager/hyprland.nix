{...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      bind = [
        "SUPER, RETURN, exec, kitty"
        "SUPER, Q, killactive"
        "SUPER, SPACE, exec, wofi --show drun"
        "SUPER, F, fullscreen"
      ];
    };
  };
}
