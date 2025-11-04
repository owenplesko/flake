{...}: let
  vault = "vault";
in {
  stylix.targets.obsidian.vaultNames = ["${vault}"];

  programs.obsidian = {
    enable = true;

    vaults."${vault}" = {
      enable = true;
    };
  };
}
