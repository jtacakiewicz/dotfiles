{ config, pkgs, ... }:

{
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;

    virtualHosts."localhost" = {
      default = true;
      locations."/" = {
        proxyPass = "http://localhost:8123"; # Replace with your actual local service
      };
    };
  };

  # Optional: expose port 80 for access
  networking.firewall.allowedTCPPorts = [ 80 ];
}
