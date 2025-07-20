{ config, pkgs, inputs, ... }:

{
    imports = [
        inputs.nix-colors.homeManagerModules.default
        ./modules/coding.nix
        ./modules/gaming.nix
        ./modules/ollama.nix
    ];
    home.username = "jan";
    home.homeDirectory = "/home/jan";

    home.stateVersion = "24.11"; 

    nixpkgs.config.allowUnfree = true;

    colorScheme = inputs.nix-colors.colorSchemes.nord;
    home.packages = [
        pkgs.gnomeExtensions.tiling-assistant
        pkgs.gnome-screenshot
        pkgs.gnomeExtensions.hide-top-bar

        pkgs.git
        pkgs.neovim

        pkgs.xclip
        pkgs.htop

        pkgs.gimp
        pkgs.mpv

        pkgs.libGL
        pkgs.obsidian
        # pkgs.discord
        pkgs.proton-pass
        pkgs.spotify

    ];
    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    dconf.settings = {
        "org/gnome/settings-daemon/plugins/media-keys" = {
            custom-keybindings = [ 
                "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
                "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
            ];
        };
        "org/gnome/desktop/wm/keybindings".close = ["<Alt>q"];
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
            { 
                binding = "<Primary><Alt>t";
                command = "alacritty";
                name = "open-terminal";
            };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" =
            { 
                binding = "<Super><Shift>s";
                command = "gnome-screenshot -i";
                name = "screenshot tool";
            };
        "org/gnome/desktop/wm/keybindings" = {
            move-to-workspace-left = ["<Super><Control>Left"];
            move-to-workspace-right = ["<Super><Control>Right"];
            move-to-monitor-left = ["<Super><Shift>Left"];
            move-to-monitor-right = ["<Super><Shift>Right"];
            switch-to-workspace-right = ["<Control>Right"];
            switch-to-workspace-left = ["<Control>Left"];
            switch-windows = ["<Alt>Tab"];
            switch-windows-backward = ["<Shift><Alt>Tab"];
        };
        "org/gnome/shell/extensions/tiling-assistant" = {
            tile-right-half =      ["<Control><Alt>Right"];
            tile-left-half =       ["<Control><Alt>Left"];
            tile-top-half =        ["<Control><Alt>Up"];
            tile-bottom-half =     ["<Control><Alt>Down"];
            tile-topleft-quarter=  ["<Shift><Control><Alt>Left"];
            tile-topright-quarter= ["<Shift><Control><Alt>Right"];
            tile-bottomleft-quarter=  ["<Super><Control><Alt>Left"];
            tile-bottomright-quarter= ["<Super><Control><Alt>Right"];
        };
    };
    home.file = {
        # # Building this configuration will create a copy of 'dotfiles/screenrc' in
        # # the Nix store. Activating the configuration will then make '~/.screenrc' a
        # # symlink to the Nix store copy.
        # ".screenrc".source = dotfiles/screenrc;

        # # You can also set the file content immediately.
        # ".gradle/gradle.properties".text = ''
        #   org.gradle.console=verbose
        #   org.gradle.daemon.idletimeout=3600000
        # '';
    };

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. These will be explicitly sourced when using a
    # shell provided by Home Manager. If you don't want to manage your shell
    # through Home Manager then you have to manually source 'hm-session-vars.sh'
    # located at either
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    # or
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    # or
    #  /etc/profiles/per-user/jan/etc/profile.d/hm-session-vars.sh
    home.sessionVariables = {
        EDITOR = "nvim";
    };
    programs.home-manager.enable = true;

}
