{ config, pkgs, options, ... }:
{
  imports = [ /etc/nixos/hardware-configuration.nix ];

  # allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      # required for lutris package
      "p7zip-16.02"
    ];
  };

  # use the latest kernel available
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # libvirtd (qemu)
  virtualisation.libvirtd.enable = true;
  boot.kernelModules = [ "kvm-amd" "kvm" ];

  # investigate
  hardware.enableRedistributableFirmware = true;

  # opengl
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;

  # use amdgpu driver
  services.xserver.videoDrivers = [ "amdgpu" ];

  # vpn
  services.openvpn.servers = {
    expressvpn = { config = "config /root/nixos/openvpn/expressvpn.conf"; };
  };

  # support 32-bit steam application
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;

  # boot options
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  # grub UEFI config
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.device = "nodev";
  boot.loader.systemd-boot.enable = true;

  # systemd
  systemd.coredump.enable = true;

  # LUKS config
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/nvme0n1p2";
      preLVM = true;
    };
  };

  # networking
  networking.hostName = "voidheart";
  networking.useDHCP = false;
  networking.interfaces.enp5s0.useDHCP = true;

  # console config
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";

  # locale settings
  i18n = { defaultLocale = "en_US.UTF-8"; };
  time.timeZone = "America/New_York";

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
    scrot
    compton
    xscreensaver
    rofi
    dmenu
  ];

  # enable docker
  virtualisation.docker.enable = true;

  # gamecube adapter support
  services.udev.extraRules = ''
    # gamecube wii u usb adapter
    ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="666", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device" TAG+="uaccess"
  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "ctrl:nocaps";

  # desktopManager
  services.xserver.displayManager.defaultSession = "none+xmonad";
  services.xserver.desktopManager.xterm.enable = false;

  # xmonad (nixos managed)
  services.xserver.windowManager.openbox.enable = true;
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    extraPackages = haskellPackages: [ haskellPackages.taffybar ];
  };

  # users
  users.users.djanatyn = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "audio" ];
    shell = pkgs.zsh;
  };

  # allow sudo without password for wheel
  security.sudo.wheelNeedsPassword = false;

  # turn on local ssh
  services.sshd.enable = true;

  # started system at 19.09
  # (don't update unless you know what you're doing)
  system.stateVersion = "19.09";
}
