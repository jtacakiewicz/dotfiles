{ pkgs, inputs, home-manager }:

{
    ogisui = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
            ./common.nix
            ./common-gui.nix
            ./ogisui.nix
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

