{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };

    # Opinionated: disable channels
    channel.enable = false;  

    # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Greeter
  programs.dconf.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'sway --unsupported-gpu'";
	user = "greeter";
      }; 
    };
  };

  # Timezone and locale
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8"; 

  fonts.packages = with pkgs; [
    maple-mono.NF-unhinted
  ];

  stylix = {
    enable = true;
    polarity = "dark";
    image = ../assets/backgrounds/pixel_galaxy.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/moonlight.yaml";
    fonts = {
      monospace = {
        package = pkgs.maple-mono.NF-unhinted;
        name = "Maple Mono";
      };
    };
  };

  # Sway WM
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  }; 

  # System Packages
  environment.systemPackages = with pkgs; [
    neovim
    git
    bat
    xclip 
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    mako # notification system developed by swaywm maintainer 
  ]; 

  # System Programs
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  # NVidia drivers
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
  };
  environment.variables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_RENDERER = "vulkan";
  };

  # Host
  networking.hostName = "nixos";

  # Users
  users.users = {
    owen = {
      initialPassword = "password";
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager"];
    };
  };

  # Setup home-manager
  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      owen = import ../home-manager/home.nix;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
