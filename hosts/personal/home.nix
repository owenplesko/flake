{...}: {
  imports = [
    ../../modules/home-manager/programs
    ../../modules/home-manager/ui
  ];

  programs.home-manager.enable = true;

  home = {
    username = "owen";
    homeDirectory = "/home/owen";
    stateVersion = "23.05";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
