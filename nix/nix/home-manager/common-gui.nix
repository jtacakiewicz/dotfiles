{ config, pkgs, inputs, ... }:

{
    home.stateVersion = "24.11"; 

    nixpkgs.config.allowUnfree = true;

    colorScheme = inputs.nix-colors.colorSchemes.nord;
    home.packages = with pkgs; [
        obsidian
        spotify
        firefox
    ];
    services.syncthing = {
        enable = true;
    };
    programs.home-manager.enable = true;

}
