{ pkgs, ... }: {
  # use the latest kernel available
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # enable kvm kernel modules
  boot.kernelModules = [ "kvm-amd" "kvm" ];
  boot.extraModulePackages = with pkgs; [ linuxPackages_latest.v4l2loopback ];

  # boot options
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  # grub UEFI config
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.device = "nodev";
  boot.loader.systemd-boot.enable = true;

  # LUKS config
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/nvme0n1p2";
      preLVM = true;
    };
  };

  # console config
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";
}
