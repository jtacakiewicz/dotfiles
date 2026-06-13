{ config, pkgs, inputs, ... }:

{
    imports = [
        ./modules/firefox.nix
    ];
    home.stateVersion = "24.11"; 

    nixpkgs.config.allowUnfree = true;

    colorScheme = inputs.nix-colors.colorSchemes.nord;
    home.packages = with pkgs; [
        obsidian
        spotify
    ];
    services.syncthing = {
        enable = true;
    };
    programs.home-manager.enable = true;

}
