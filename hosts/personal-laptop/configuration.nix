
{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  nixpkgs = {
    config.allowUnfree = true;
  };

  nix = {
    settings.experimental-features = "nix-command flakes";
    channel.enable = false;
  };

  # users
 system.primaryUser = "owen";

  users.users.owen = {
    home = "/Users/owen";
    shell = pkgs.zsh;
  };

  # home-manager integration
  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs;};
    users.owen = import ./home.nix;
  };

  system.stateVersion = 6;
}
