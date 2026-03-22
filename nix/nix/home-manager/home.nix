{ pkgs, inputs, home-manager }:

{
    nixos = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
            ./common.nix
            ./common-gui.nix
            ./nixos.nix
        ];
    };

    darwin = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
            ./common.nix
            ./common-gui.nix
            ./macos.nix
        ];
    };

    truncatum = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
            ./common.nix
            ./truncatum.nix
        ];
    };
}

