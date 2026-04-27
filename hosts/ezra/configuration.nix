{ config, pkgs, libs, inputs, outputs, ... }:

{
  ##################################################
  # Imports
  ##################################################
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  ##################################################
  # Nix Settings
  ##################################################
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow proprietary packages (NVIDIA, Steam, etc.)
  nixpkgs.config.allowUnfree = true;

  ##################################################
  # Bootloader
  ##################################################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Latest kernel (good performance, but occasionally unstable)
  boot.kernelPackages = pkgs.linuxPackages_latest;

  ##################################################
  # Networking
  ##################################################
  networking.hostName = "ezra";
  networking.networkmanager.enable = true;

  ##################################################
  # Time / Locale
  ##################################################
  time.timeZone = "America/Jamaica";
  i18n.defaultLocale = "en_US.UTF-8";

  ##################################################
  # Desktop (KDE Plasma 6)
  ##################################################
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # --------------------------------------------------------
  # Audio (PipeWire)
  # --------------------------------------------------------
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;

    pulse.enable = true;

    # Required for Bluetooth audio devices
    wireplumber.enable = true;
  };

  # --------------------------------------------------------
  # Bluetooth
  # --------------------------------------------------------
  hardware.bluetooth = {
    enable = true;

    # Turn on Bluetooth automatically at boot
    powerOnBoot = true;

    # Better device compatibility
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  # GUI Bluetooth manager (very helpful for KDE)
  services.blueman.enable = true;

  # --------------------------------------------------------
  # Printing
  # --------------------------------------------------------
  services.printing.enable = true;

  # --------------------------------------------------------
  # Graphics (NVIDIA)
  # --------------------------------------------------------
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = false;
    powerManagement.finegrained = false;

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # --------------------------------------------------------
  # User Account
  # --------------------------------------------------------
  users.users.ezra = {
    isNormalUser = true;
    description = "ezra";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  # --------------------------------------------------------
  # Programs
  # --------------------------------------------------------
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.steam.enable = true;

  # --------------------------------------------------------
  # Packages
  # --------------------------------------------------------
  environment.systemPackages = with pkgs; [
    vim
    git
    fzf
    gcc
    curl
    wget
    unzip
    kitty
    gnumake
    direnv
    tree-sitter
    bibata-cursors

    # KWin blur effect (Wayland + X11)
    inputs.kwin-effects-better-blur-dx.packages.${pkgs.system}.default # Wayland
    inputs.kwin-effects-better-blur-dx.packages.${pkgs.system}.x11 # X11

    # Catppuccin theming
    (catppuccin-kde.override {
      flavour = [ "mocha" ];
      accents = [ "mauve" ];
    })
  ];

  # --------------------------------------------------------
  # Services
  # --------------------------------------------------------
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.allowSFTP = true;
  services.openssh.settings.PasswordAuthentication = false;


  # --------------------------------------------------------
  # Qt configuration
  # --------------------------------------------------------
  qt = {
    enable = true;
    style = "kvantum";
  };

  # --------------------------------------------------------
  # System version
  # --------------------------------------------------------
  system.stateVersion = "25.11";
}
