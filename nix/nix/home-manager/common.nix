{ config, pkgs, inputs, ... }:

{
    imports = [
        inputs.nix-colors.homeManagerModules.default
        ./modules/coding.nix
        ./modules/firefox.nix
    ];
    home.stateVersion = "24.11"; 

    nixpkgs.config.allowUnfree = true;

    colorScheme = inputs.nix-colors.colorSchemes.nord;
    home.packages = with pkgs; [
        git
        neovim
        xclip
        htop
        syncthing
    ];
    services.syncthing = {
        enable = true;
    };
    programs.home-manager.enable = true;

}
