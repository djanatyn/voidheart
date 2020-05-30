{ config, pkgs }: {
  # opengl
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;

  # support 32-bit steam application
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];

  # use amdgpu driver
  services.xserver.videoDrivers = [ "amdgpu" ];

  # investigate
  hardware.enableRedistributableFirmware = true;
}
