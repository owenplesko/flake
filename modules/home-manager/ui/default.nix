{pkgs, ...}: {
  imports = [./hyprland ./waybar ./wofi];

  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    hyprcursor.enable = true;
  };

  home.packages = with pkgs; [
    nemo
  ];
}
