{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    ./hardware-configuration.nix
    ../../modules/nixos/secrets.nix
  ];

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs;};
    users = {
      owen = import ./home.nix;
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "home-server";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Xfce Desktop Environment.
  services.xserver.desktopManager.xfce.enable = true;
  services.xrdp.defaultWindowManager = "xfce4-session";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable network storage
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      media = {
        path = "/mnt/media";
        browseable = "yes";
        writable = "yes";
        "valid users" = "owen";
      };
    };
  };
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."owen" = {
    isNormalUser = true;
    description = "owen plesko";
    extraGroups = ["networkmanager" "wheel" "media"];
  };

  services.secrets = {
    enable = true;
    keyFile = "/etc/sops/age/keys.txt";
    secretFiles = {
      shared = true;
      server01 = true;
    };
  };

  # Define media services
  users.groups.media = {};
  systemd.tmpfiles.rules = [
    "z /mnt/media 0775 root media - -"
  ];

  sops.templates."sabnzbd-secrets.ini" = {
    content = ''
      [servers]
      [[frugal-us-east]]
      username = ${config.sops.placeholder."frugal/username"}
      password = ${config.sops.placeholder."frugal/password"}
    '';
    owner = "sabnzbd";
    mode = "0400";
  };

  services.sabnzbd = {
    enable = true;
    group = "media";
    openFirewall = true;
    secretFiles = [config.sops.templates."sabnzbd-secrets.ini".path];
    settings = {
      host = "0.0.0.0";
      servers = {
        "frugal-us-east" = {
          name = "Frugal US East";
          displayname = "Frugal US East";
          host = "news.frugalusenet.com";
          ssl = true;
          ssl_verify = "strict";
        };
      };
    };
  };

  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };

  services.radarr = {
    enable = true;
    openFirewall = true;
    group = "media";
  };

  services.sonarr = {
    enable = true;
    openFirewall = true;
    group = "media";
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    group = "media";
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow nix-command and flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    git
  ];

  # enable remote desktop server
  services.xrdp = {
    enable = true;
    openFirewall = true;
  };

  system.stateVersion = "26.05";
}
