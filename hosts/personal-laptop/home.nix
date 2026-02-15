
{
  inputs,
  config,
  ...
}: {
  imports = [
    ../../modules/home-manager/programs/nvim
  ];

  programs.home-manager.enable = true;

  home = {
    username = "owen";
    homeDirectory = "/home/owen";
    stateVersion = "23.05";
  };
}
