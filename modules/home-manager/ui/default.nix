{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hyprland
    #./waybar
    #./wofi
  ];

  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    hyprcursor.enable = true;
  };

  gtk.gtk4.theme = config.gtk.theme;

  home.packages = with pkgs; [
    nemo
  ];
}
