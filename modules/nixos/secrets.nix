{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.services.secrets;

  # Define structure of sops secrets here.
  structure = {
    shared = {
      path = ../../secrets/shared.yaml;
      secrets = {
        "github/pat" = {};
      };
    };
    desktop01 = {
      path = ../../secrets/desktop01.yaml;
      secrets = {
      };
    };
    server01 = {
      path = ../../secrets/server01.yaml;
      secrets = {
        "frugal/username" = {};
        "frugal/password" = {};
      };
    };
  };

  # Helper function for filtering secretFiles by enabled options.
  enabledSecrets =
    lib.filterAttrs
    (name: enabled: enabled && structure ? ${name})
    cfg.secretFiles;

  # Helper function for transforming enabled secret keys into sops-nix config.
  resolveSecrets =
    lib.concatMapAttrs (
      fileName: _: let
        # Look up the actual file configurations from our static structure
        fileConfig = structure.${fileName};
      in
        builtins.mapAttrs (
          secretName: secretOpts:
            secretOpts // {sopsFile = fileConfig.path;}
        )
        fileConfig.secrets
    )
    enabledSecrets;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options.services.secrets = {
    enable = lib.mkEnableOption "My Secrets Module";
    keyFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to your secret key for sops.";
    };
    secretFiles = lib.mkOption {
      type = lib.types.attrsOf lib.types.bool;
      default = builtins.mapAttrs (name: _: false) structure;
      description = "Enable secret files used.";
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      age.keyFile = cfg.keyFile;
      secrets = resolveSecrets;
    };
  };
}
