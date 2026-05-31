{ pkgs, config, ... }:

{
    home.packages = [
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.alacritty
    ];
    home.sessionVariables = {
        TERMINAL = "alacritty";
    };
    xdg.terminal-exec = {
        enable = true;
        settings.default = [ "alacritty" ];
    };
}
