{
    description = "local dns setup";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    };

    outputs = { self, nixpkgs }: {
        nixosModules.blocky-container = { config, pkgs, lib, ... }: {

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

                    services.blocky = {
                        enable = true;
                        settings = {
                            ports.dns = 53;
                            upstreams.groups.default = [
                                "https://one.one.one.one/dns-query"
                            ];
                            bootstrapDns = {
                                upstream = "1.1.1.1";
                            };
                            blocking = {
                                denylists = {
                                    ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
                                    adult = ["https://blocklistproject.github.io/Lists/porn.txt"];
                                };
                                clientGroupsBlock = {
                                    default = [ "ads" ];
                                    kids-ipad = ["ads" "adult"];
                                };
                            };
                        };
                    };

                };
            };

            networking.nat = {
                enable = true;
                internalInterfaces = [ "ve-dns" ];
                externalInterface = "eno1";
            };
            networking.firewall.allowedUDPPorts = [ 53 ];
            networking.firewall.allowedTCPPorts = [ 53 ];
        };
    };
}
