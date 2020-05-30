{ config, pkgs }: {
  # networking
  networking.hostName = "voidheart";

  # no DHCP on any interface but enp5s0
  networking.useDHCP = false;
  networking.interfaces.enp5s0.useDHCP = true;

  # traceroute
  programs.mtr.enable = true;

  # sshd service
  services.sshd.enable = true;

  # openvpn
  services.openvpn.servers = {
    expressvpn = { config = "config /root/nixos/openvpn/expressvpn.conf"; };
  };
}
