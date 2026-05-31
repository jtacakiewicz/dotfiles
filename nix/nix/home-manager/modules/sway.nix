
{ config, pkgs, ... }:

{
    home.pointerCursor = {
        name = "macOS";
        package = pkgs.apple-cursor;

        size = 24;
    };
    home.packages = with pkgs; [
        tofi # app launcher
        yazi # file manager
        grim # ss tool
        slurp # ss tool
        wl-clipboard # clipboard
        jq # scripts
    ];
    programs.zathura = {
        enable = true;
        options = {
            recolor = true;

            recolor-keephue = true; 

            recolor-reverse-video = true;
            default-bg = "#2e3440";
            default-fg = "#d8dee9";
            recolor-lightcolor = "#2e3440"; # Map white pages to Nord Dark
            recolor-darkcolor = "#eceff4";  # Map black text to Nord Light
        };
    };

    xdg.mimeApps.defaultApplications = {
        "application/pdf" = [ "zathura" ];
    };
    programs.waybar.enable = true;
}
