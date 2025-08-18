{ config, pkgs, lib, ... }:

{
  home.username = "ph";
  home.homeDirectory = "/home/ph";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    libreoffice
    wget
    tmux
    discord
    sway
    brave
    kitty
    rofi
    wl-clipboard
    mako # sway notif system

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    fzf # A command-line fuzzy finder
    shellcheck

    # networking tools
    dnsutils  # `dig` + `nslookup`
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses

    # misc
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    glow # markdown previewer in terminal

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ];

  services.gnome-keyring.enable = true;

  wayland.windowManager.sway = {
    enable = true;

    config = {
      modifier = "Mod4"; # Set mod to Super key

      terminal = "${pkgs.kitty}";
      menu = "${pkgs.rofi}/bin/rofi -show drun";

      keybindings = lib.mkOptionDefault {
        "Mod4+Return" = "exec ${pkgs.kitty}/bin/kitty";
        "Mod4+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
        "Mod4+Shift+z" = "exec ${pkgs.brave}/bin/brave";
      };
    };
  };

  programs.vim.enable = true;
  programs.vim.defaultEditor = true;

  programs.git = {
    enable = true;
    userName = "Philip Roberts";
    userEmail = "philip@philip.science";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      l="ls -la";
      c="clear";
      g="git";
      gs="git status";
      t="tmux";
      ta="tmux attach";
      b="vim ~/.bashrc";
      py="python3";
      config="sudoedit /etc/nixos/configuration.nix";
      home="sudoedit /etc/nixos/home.nix";
      switch="sudo nixos-rebuild switch";
      unlock_brave_profile="rm -rf .config/BraveSoftware/Brave-Browser/SingletonLock";
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}
