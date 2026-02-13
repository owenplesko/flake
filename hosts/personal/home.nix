{inputs, ...}: {
  imports = [
    ../../modules/home-manager/programs
  ];

  programs.home-manager.enable = true;

  home = {
    username = "owen";
    homeDirectory = "/home/owen";
    stateVersion = "23.05";
  };

  nixpkgs.overlays = [inputs.nur.overlays.default];
}
