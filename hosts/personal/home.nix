{
  inputs,
  config,
  ...
}: {
  imports = [
    ../../modules/home-manager/programs
    inputs.sops-nix.homeManagerModules.sops
  ];

  programs.home-manager.enable = true;

  home = {
    username = "owen";
    homeDirectory = "/home/owen";
    stateVersion = "23.05";
  };

  # sops configuration
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };

  sops.secrets."github-pat" = {
    path = "${config.home.homeDirectory}/.config/git/github-pat";
    mode = "0600";
  };

  programs.git = {
    settings = {
      credential.helper = "!f() { echo username=YOUR_GITHUB_USERNAME; echo password=$(cat ~/.config/git/github-pat); }; f";
    };
  };

  # silence warning
  gtk.gtk4.theme = config.gtk.theme;

  nixpkgs.overlays = [inputs.nur.overlays.default];
}
