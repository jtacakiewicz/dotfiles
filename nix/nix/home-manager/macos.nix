{ config, pkgs, lib, inputs, ... }:

{
    imports = [
        inputs.nix-colors.homeManagerModules.default
    ];
    home.username = "epi";
    home.homeDirectory = "/Users/epi";

    home.stateVersion = "24.11"; 

    nixpkgs.config.allowUnfree = true;

    colorScheme = inputs.nix-colors.colorSchemes.nord;
    home.packages = with pkgs; [
    ];
    # Simple script
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    # home.file = {
    #     # ".screenrc".source = dotfiles/screenrc;
    # };

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

}
