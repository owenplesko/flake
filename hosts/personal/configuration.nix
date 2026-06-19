{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/secrets.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
  ];

  # system identity
  networking.hostName = "nixos";
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # nix settings
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

  # users
  users.users = {
    owen = {
      initialPassword = "password";
      isNormalUser = true;
      extraGroups = ["video" "wheel" "networkmanager" "docker"];
    };
  };

  # secrets
  services.secrets = {
    enable = true;
    keyFile = "/etc/sops/age/keys.txt";
    secretFiles = {
      shared = true;
      desktop01 = true;
    };
  };

  # bootloader
  boot.loader.grub = {
    enable = true;
    device = "/dev/nvme0n1";
  };

  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;
  services.system76-scheduler.enable = true;

  # style
  fonts.packages = with pkgs; [
    maple-mono.NF-unhinted
    font-awesome
  ];

  stylix = {
    enable = true;
    image = ../../assets/backgrounds/pixel_galaxy.png;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    fonts = {
      monospace = {
        package = pkgs.maple-mono.NF-unhinted;
        name = "Maple Mono NF";
      };
    };
  };

  # system packages
  environment.systemPackages = with pkgs; [
    neovim
    git
  ];

  virtualisation.docker.enable = true;

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  # PORTAL
  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  hardware.bluetooth.enable = true;

  # NVidia drivers
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true;
  };
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];
  environment.sessionVariables = {
    WLR_DRM_NO_MODIFIERS = "1";
    GDM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    COSMIC_DATA_CONTROL_ENABLED = 1;
    NIXOS_OZONE_WL = "1";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
