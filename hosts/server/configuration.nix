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
        path = "/media";
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

  # Home assistant
  services.openthread-border-router = {
    enable = true;
    backboneInterfaces = ["eno1"];
    openFirewall = true;
    radio.device = "/dev/serial/by-id/usb-Nabu_Casa_ZBT-2_E072A1DC13F4-if00";
    radio.url = "spinel+hdlc+uart:///dev/serial/by-id/usb-Nabu_Casa_ZBT-2_E072A1DC13F4-if00?uart-baudrate=460800";
  };

  services.home-assistant = {
    enable = true;
    openFirewall = true;
    extraComponents = [
      "default_config"
      "thread"
      "matter"
      "otbr"
    ];
    config = {
      default_config = {};
    };
  };

  services.home-assistant-matter-hub = {
    enable = true;
    openFirewall = true;
    accessTokenFile = config.sops.secrets.ha_token.path;
    settings = {
      homeAssistantUrl = "http://127.0.0.1:8123";
    };
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
    "d /media/Downloads/incomplete 0775 - media - -"
    "d /media/Downloads/complete   0775 - media - -"
    "d /media/Movies               0775 - media - -"
    "d /media/Shows                0775 - media - -"
    "d /media/Pictures             0775 - media - -"
  ];

  sops.templates."sabnzbd-secrets.ini" = {
    content = ''
      [servers]
      [[frugal-us-east]]
      username = ${config.sops.placeholder."frugal/username"}
      password = ${config.sops.placeholder."frugal/password"}
      [misc]
      api_key = ${config.sops.placeholder."sabnzdb/api_key"}
      nzb_key = ${config.sops.placeholder."sabnzdb/nzb_key"}
    '';
    owner = "sabnzbd";
    mode = "0400";
  };

  services.sabnzbd = {
    enable = true;
    openFirewall = true;
    group = "media";
    secretFiles = [config.sops.templates."sabnzbd-secrets.ini".path];
    settings = {
      misc = {
        host = "0.0.0.0";
        download_dir = "/media/Downloads/incomplete";
        complete_dir = "/media/Downloads/complete";
        permissions = "775";
      };
      servers = {
        "frugal-us-east" = {
          name = "Frugal US East";
          displayname = "Frugal US East";
          host = "news.frugalusenet.com";
          ssl = true;
          ssl_verify = "strict";
          connections = 50;
        };
        "frugal-bonus" = {
          name = "Frugal Bonus";
          displayname = "Frugal Bonus";
          host = "bonus.frugalusenet.com";
          ssl = true;
          ssl_verify = "strict";
          connections = 10;
          priority = 1;
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
