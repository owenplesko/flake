
{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs = {
    config.allowUnfree = true;
  };

  nix = {
    settings.experimental-features = "nix-command flakes";
    channel.enable = false;
  };

  # home-manager integration
  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs;};
    users = {
      owen = import ./home.nix;
    };
  };

  system.stateVersion = 6;
}
