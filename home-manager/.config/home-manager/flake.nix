{
    description = "Home Manager configuration of jan";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-colors.url = "github:misterio77/nix-colors";
    };

    outputs = { nixpkgs, home-manager, ... }@inputs:
        let
            systems = {
                darwin = "aarch64-darwin";
                linux = "x86_64-linux";
            };
        in
            rec {
            {
            homeConfigurations = {
                nixos = home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    extraSpecialArgs = { inherit inputs; };
                    modules = [
                        ./common.nix
                        ./nixos.nix
                    ];
                };
                darwin = home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    extraSpecialArgs = { inherit inputs; };
                    modules = [
                        ./common.nix
                        ./macos.nix
                    ];
                };
            };
        };
}

