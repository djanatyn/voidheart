{ config, pkgs }: {
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
}
