{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
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

  networking.hostName = "nixos"; # Define your hostname.

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
  services.nfs.server = {
    enable = true;
    exports = ''
      /mnt/media 192.168.1.0/24(rw,sync,no_subtree_check)
    '';
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."owen" = {
    isNormalUser = true;
    description = "owen plesko";
    extraGroups = ["networkmanager" "wheel"];
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
