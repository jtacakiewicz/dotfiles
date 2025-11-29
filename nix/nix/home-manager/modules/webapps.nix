{ pkgs, ... }:

{

    home.packages = [
        pkgs.chromium
    ];
    home.file.".local/share/applications/my-webapp.desktop".text = ''
        [Desktop Entry]
        Version=1.0
        Type=Application
        Name=Discord
        Exec=${pkgs.chromium}/bin/chromium --app=https://discord.com/channels/@me
        Icon=chromium
        Terminal=false
        Categories=Network;
    '';

}

