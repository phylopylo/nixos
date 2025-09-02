{ config, pkgs, lib, ... }:

let
  hostName = "diary8";
  enableSSH = true;
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  system.stateVersion = "25.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # =========== System Configuration ==========
  users.users.ph = {
    isNormalUser = true;
    description = "Philip Roberts";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/New_York";
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

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  security.polkit.enable = true;

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # ========== Configuration ==========
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    networkmanager
    tigervnc
  ];

  environment.variables = {
    GBM_BACKEND = "nvidia-drm";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    NVD_BACKEND = "direct";
    GDK_SCALE = "1.5";
    GDK_DPI_SCALE = "0.5";
    QT_SCALE_FACTOR = "1.5";
    XCURSOR_SIZE = "48";
  };


  # ========== Network Configuration ==========
  networking.hostName = hostName;
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = if enableSSH then [ 22 ] else [];

  services.openssh = {
    enable = enableSSH;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = [ "ph" ]; # Allows all users by default. Can be [ "user1" "user2" ]
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  # ========== Display Server Configuration ==========
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["nvidia"];

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "sway";
  services.xrdp.openFirewall = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd \"sway --unsupported-gpu\"";
        user = "greeter";
      };
    };
  };

  # ========== GPU Configuration ==========
  hardware.nvidia = {
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
  };

  # =========== Bluetooth Configuration ==========
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
    };
  };
}
