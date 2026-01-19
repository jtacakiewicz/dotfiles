
{ config, pkgs, inputs, ... }:

{
    imports = [
        ./modules/linux-gaming.nix
        ./modules/ollama.nix
        ./modules/linux-keybinds.nix
        ./modules/webapps.nix
    ];
    home.username = "jamjan";
    home.homeDirectory = "/home/jamjan";
}
