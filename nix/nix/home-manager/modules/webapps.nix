{ config, pkgs, ... }:

{
    home.file.".local/share/icons/discord.svg".source = ./assets/discord.svg;
    home.file.".local/share/icons/nixos.svg".source = ./assets/nixos.svg;
    home.file.".local/share/icons/messenger.svg".source = ./assets/messenger.svg;

    home.file.".local/share/applications/discord-web.desktop".text = ''
        [Desktop Entry]
        Version=2.0
        Type=Application
        Name=Discord
        Exec=${pkgs.firefox}/bin/firefox -P kiosk --name discord --new-window https://discord.com/channels/@me
        Icon=discord
        Terminal=false
        Categories=Network;
    '';

    home.file.".local/share/applications/nixpkgs-web.desktop".text = ''
        [Desktop Entry]
        Version=2.0
        Type=Application
        Name=Nix pkgs
        Exec=${pkgs.firefox}/bin/firefox -P kiosk --name nixpkgs --new-window https://search.nixos.org/packages
        Icon=nixos
        Terminal=false
        Categories=Network;
    '';

    home.file.".local/share/applications/messenger.desktop".text = ''
        [Desktop Entry]
        Version=2.0
        Type=Application
        Name=Messenger
        Exec=${pkgs.firefox}/bin/firefox -P kiosk --name messenger --new-window https://www.messenger.com
        Icon=messenger
        Terminal=false
        Categories=Network;
    '';
}

