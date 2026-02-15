
{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "aarch64-darwin";
  };
  nix = {
    settings.experimental-features = "nix-command flakes";
    channel.enable = false;
  };
}
