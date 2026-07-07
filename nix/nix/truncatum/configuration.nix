
{ config, pkgs, hostLanIp, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../shared/common.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.enableContainers = true;
  virtualisation.containers.enable = true;

  networking.hostName = "truncatum";
  networking.defaultGateway =  "192.168.1.1";
  networking.nameservers = [ "10.233.0.3" "1.1.1.1" ];
  networking.networkmanager.enable = true;
  networking.networkmanager.insertNameservers = [ "10.233.0.3" "1.1.1.1" ];

  networking.interfaces.eno1.ipv4.addresses = [
    {
      address = hostLanIp;
      prefixLength = 24;
    }
  ];

  users.users.jamjan = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };
  services.openssh.enable = true;
  services.openssh.settings = {
    PasswordAuthentication=false;
    PermitRootLogin="no";
  };
  services.fail2ban.enable = true;

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 22 ];

  system.stateVersion = "25.11"; # Did you read the comment?

}

