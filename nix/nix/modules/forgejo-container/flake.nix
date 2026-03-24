{
  description = "Forgejo container module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }: {
    nixosModules.forgejo-container = { config, pkgs, lib, ... }: {

      virtualisation.containers.enable = true;

      containers.forgejo = {
        autoStart = true;
        privateNetwork = true;
        hostAddress = "10.233.0.1";
        localAddress = "10.233.0.2";

        config = { config, pkgs, ... }: {
          system.stateVersion = "24.11";

          networking.firewall.allowedTCPPorts = [ 22 3000 80 ];

          # ---- PostgreSQL ----
          services.postgresql = {
            enable = true;
            package = pkgs.postgresql_15;
            initialScript = pkgs.writeText "init.sql" ''
              CREATE USER forgejo WITH PASSWORD 'forgejo';
              CREATE DATABASE forgejo OWNER forgejo;
            '';
          };

          # ---- Forgejo ----
          services.forgejo = {
            enable = true;

            settings = {
              server = {
                DOMAIN = "git.local";
                ROOT_URL = "http://git.local/";
                HTTP_PORT = 3000;
                SSH_PORT = 22;
              };

              database = {
                DB_TYPE = lib.mkDefault "postgres";
                HOST = "127.0.0.1:5432";
                NAME = "forgejo";
                USER = "forgejo";
                PASSWD = "forgejo";
              };

              service.DISABLE_REGISTRATION = true;
            };
          };

          # ---- Reverse proxy (optional) ----
          services.caddy = {
            enable = true;
            virtualHosts."git.local".extraConfig = ''
              reverse_proxy 127.0.0.1:3000
            '';
          };
        };
      };

      # Host-side networking
      networking.nat = {
        enable = true;
        internalInterfaces = [ "ve-forgejo" ];
        externalInterface = "eth0"; # adjust if needed
      };

      networking.firewall.allowedTCPPorts = [ 80 3000 ];
    };
  };
}
