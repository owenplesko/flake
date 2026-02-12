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

  programs.ssh = {
    enable = true;
  };
  services.ssh-agent.enable = true;
  home.sessionVariables.SSH_AUTH_SOCK = "/run/user/1000/ssh-agent";

  nixpkgs.overlays = [inputs.nur.overlays.default];
}
