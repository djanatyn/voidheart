{ config, pkgs, options, ... }:
let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "8bbefa77f7e95c80005350aeac6fe425ce47c288";
    ref = "master";
  };
in {
  imports = [
    /etc/nixos/hardware-configuration.nix
    (import "${home-manager}/nixos")
    ./boot.nix
    ./network.nix
    ./graphics.nix
    ./wm.nix
    ./users.nix
  ];

  # nix configuration
  # =================

  nix.package = pkgs.nix;

  # nixpkgs configuration
  # =====================

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      # required for lutris package
      "p7zip-16.02"
    ];
  };

  # nixos configuration
  # ===================

  # (don't update unless you know what you're doing)
  system.stateVersion = "19.09";

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/New_York";

  security.sudo.wheelNeedsPassword = false;

  # gamecube adapter support
  services.udev.extraRules = ''
    # gamecube wii u usb adapter
    ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="666", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device" TAG+="uaccess"
  '';

  systemd.coredump.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    # network
    networkmanagerapplet

    # for finding SHA256 hashes
    nix-prefetch-scripts

    # browser
    firefox
    tor-browser-bundle-bin

    # nix
    nixfmt
    nox
    patchelf
    morph

    # system
    zsh
    htop
    which
    file
    dnsutils
    whois
    mtr
    binutils
    rxvt_unicode
    rsync
    exa
    tmux

    # virtualisation.xen.trace
    qemu_kvm

    # fonts
    terminus_font
    terminus_font_ttf

    # java
    openjdk11

    # archives
    unzip
    unrar

    # utilities
    unrar
    xclip
    aspell
    silver-searcher
    bat
    fzy

    # hashicorp
    terraform
    packer
    nomad

    # music
    spotify

    # ansible
    ansible
    ansible-lint

    # chat
    discord
    spectral

    # torrent
    rtorrent

    # media
    vlc
    pavucontrol

    # environment
    chezmoi

    # editor
    emacs
    vim

    # development
    gdb
    git
    gist
    git-lfs
    gitAndTools.pre-commit
    gitAndTools.diff-so-fancy
    google-cloud-sdk
    cloc

    # haskell
    stack
    ormolu

    # secrets
    gnupg
    diceware
    pass
    sshpass
    keybase

    # ssh
    assh
    sshuttle

    # games
    runelite
    (retroarch.override {
      cores = [
        libretro.dosbox
        libretro.desmume
        libretro.mupen64plus
        libretro.nestopia
        libretro.snes9x
        libretro.dolphin
        libretro.prboom
        libretro.vba-m
      ];
    })
    lutris
    (pkgs.wine.override { wineBuild = "wineWow"; })
    steam
    lutris
    sgtpuzzles
    multimc
    eidolon

    # streaming
    obs-studio

    # window management
    nitrogen
    arandr
    xmobar
    compton
    maim
    xscreensaver
    rofi
    wmctrl
  ];
}
