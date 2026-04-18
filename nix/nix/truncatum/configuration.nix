
{ config, pkgs, hostLanIp, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.enableContainers = true;
  virtualisation.containers.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.networkmanager.enable = true;
  networking.hostName = "truncatum";
  networking.defaultGateway =  "192.168.1.1";
  networking.nameservers = [ "10.233.0.3" "1.1.1.1" ];
  networking.networkmanager.insertNameservers = [ "10.233.0.3" "1.1.1.1" ];

  networking.interfaces.eno1.ipv4.addresses = [
    {
      address = hostLanIp;
      prefixLength = 24;
    }
  ];



  # Set your time zone.
  time.timeZone = "Europe/Warsaw";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  programs.zsh.enable = true;
  users.users.jamjan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };
  services.openssh.enable = true;
  services.openssh.settings = {
    PasswordAuthentication=false;
    PermitRootLogin="no";
  };
  services.tailscale.enable = true;
  networking.firewall = {
    enable=true;
    allowedUDPPorts = [ config.services.tailscale.port ];
    interfaces."tailscale0".allowedTCPPorts = [ 22 ];
  };

  services.fail2ban.enable = true;

  system.stateVersion = "25.11"; # Did you read the comment?

}

