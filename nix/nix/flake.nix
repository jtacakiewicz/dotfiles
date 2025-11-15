{
    description = "Unified Darwin + Home Manager flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

        nix-darwin = {
            url = "github:LnL7/nix-darwin";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, ... }:
            {
            # -----------------------------
            # 1) Darwin system configuration
            # -----------------------------
            darwinConfigurations."Jans-MacBook-Air" = nix-darwin.lib.darwinSystem {
                system =  "aarch64-darwin";
                modules = [
                    darwin/macos-conf.nix
                    home-manager.darwinModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;

                        home-manager.users.epi = import home-manager/home.nix;
                    }
                ];
            };

            # -------------------------------------
            # 2) Home-Manager standalone (optional)
            # -------------------------------------
            homeConfigurations = import ./home.nix {
                inherit pkgs inputs home-manager;
            };        
        };
}

