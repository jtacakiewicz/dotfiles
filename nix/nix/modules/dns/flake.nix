{
  description = "dnsmasq container module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs }: {
    nixosModules.dns-container = { config, pkgs, lib, ... }: {

      virtualisation.containers.enable = true;

      containers.dns = {
        autoStart = true;
        privateNetwork = true;

        hostAddress = "10.233.0.1";
        localAddress = "10.233.0.3";
        forwardPorts = [
          { protocol = "udp"; hostPort = 53; containerPort = 53; }
          { protocol = "tcp"; hostPort = 53; containerPort = 53; }
        ];

        config = { config, pkgs, ... }: {
          system.stateVersion = "24.11";

          networking.firewall.allowedUDPPorts = [ 53 ];
          networking.firewall.allowedTCPPorts = [ 53 ];

          services.dnsmasq = {
            enable = true;

            settings = {
              server = [ "1.1.1.1" "8.8.8.8" ];

              address = [
                "/git.test/10.233.0.2"
              ];

              listen-address = "0.0.0.0";
              bind-interfaces = true;
            };
          };
        };
      };

      # Expose DNS from host
      networking.firewall.allowedUDPPorts = [ 53 ];
      networking.firewall.allowedTCPPorts = [ 53 ];
    };
  };
}
