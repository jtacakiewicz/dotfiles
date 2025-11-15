{ pkgs, inputs, home-manager }:

{
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
}

