{ config, pkgs, lib, ... }:

let
  username            = "ph";
  enableDevTools      = true;
  enableSway          = true;
  enableGnome         = false; # Nonfunctional. write (enableSway or enableGnome) assert. Add GNOME packages.
  enableDesktopApps   = true;
  enableSystemApps    = true;
  enableArchiveTools  = true;
  enableSystemUtils   = true;
  enableUnixTools     = true;

  requiredPackages = with pkgs; [
    brave
    google-chrome
  ];

  devTools = with pkgs; lib.optionals enableDevTools [
    tmux
    kitty
  ];

  sway = with pkgs; lib.optionals enableSway [
    rofi
    wl-clipboard
    mako
  ];

  desktopApps = with pkgs; lib.optionals enableDesktopApps [
    libreoffice
    discord
  ];

  systemApps = with pkgs; lib.optionals enableSystemApps [
    nautilus
    pavucontrol
  ];

  archiveTools = with pkgs; lib.optionals enableArchiveTools [
    zip
    xz
    unzip
    p7zip
  ];

  systemUtils = with pkgs; lib.optionals enableSystemUtils [
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ];

  unixTools = with pkgs; lib.optionals enableUnixTools [
    htop
    wget

    ripgrep
    jq
    yq-go
    fzf
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
  ];
in
{
  # User Setup
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  # Packages
  home.packages = requiredPackages
               ++ devTools
               ++ sway
               ++ desktopApps
               ++ systemApps
               ++ archiveTools
               ++ unixTools
               ++ systemUtils;
  
  services.gnome-keyring.enable = true;

  wayland.windowManager.sway = {
    enable = enableSway;

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

  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = '' # used for less common options, intelligently combines if defined in multiple places.
      # Reload Tmux config with greater ease
      bind r source-file ~/.tmux.conf

      # Switch panes with alt key
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Enable Mouse Control
      set -g mouse on

      # Status Bar
      set -g status-left-length 20
      set -g status-position bottom
      set -g status-style fg=#99ffff
      set -g status-right "#{?window_bigger,[#{window_offset_x}#,#{window_offset_y}], } %d-%b-%y | %H:%M "  
    '';
  };

  programs.git = {
    enable = true;
    userName = "Philip Roberts";
    userEmail = "philip@philip.science";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    #promptInit = ''PS1=\[\033]2;\h:\u:\w\007\]$PS1'';
    shellAliases = {
      # Basic Shell Interaction
      l="ls -la";
      c="clear";

      # Software Development
      g="git";
      gs="git status";
      t="tmux";
      ta="tmux attach";
      py="python3";

      # NixOS Config
      config="sudoedit /etc/nixos/configuration.nix";
      home="sudoedit /etc/nixos/home.nix";
      switch="sudo nixos-rebuild switch";
      homeswitch="home && switch";
      configswitch="config && switch";
      validate="sudo nixos-rebuild dry-build";
      llm_debug="cat /etc/nixos/home.nix > out.log && switch --show-trace &>> out.log";

      # Everything Else
      b="vim -R ~/.bashrc"; # Readonly now because you should be using the nix config, not editing the bashrc yourself
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
