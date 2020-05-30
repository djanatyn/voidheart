{ config, pkgs, ... }: {
  users.users.djanatyn = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "audio" ];
    shell = pkgs.zsh;
  };

  home-manager.users.djanatyn = {
    programs.git = {
      enable = true;
      userName = "djanatyn";
      userEmail = "djanatyn@gmail.com";
    };

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
  };
}
