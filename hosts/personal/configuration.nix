{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  # system identity
  networking.hostName = "nixos";
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # nix settings
  nixpkgs = {config.allowUnfree = true;};
  nix = {
    experimental-features = "nix-command flakes";
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
      extraGroups = ["wheel" "networkmanager" "docker"];
    };
  };

  # bootloader
  boot.loader.systemd-boot = {
    enable = true;
    efi.canTouchEfiVariables = true;
  };

  # greeter
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # style
  fonts.packages = with pkgs; [
    maple-mono.NF-unhinted
    font-awesome
  ];

  stylix = {
    enable = true;
    image = ../assets/backgrounds/pixel_galaxy.png;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/material-darker.yaml";
    opacity = {
      applications = 0.8;
      desktop = 0.8;
      popups = 0.8;
      terminal = 0.8;
    };
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
    bat
    xclip
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    dunst
  ];

  programs.hyprland.enable = true;
  #programs.hyprland.xwayland.enable = true;

  virtualisation.docker.enable = true;

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # NVidia drivers
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.open = true;
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_DRM_NO_MODIFIERS = "1";
    GDM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
