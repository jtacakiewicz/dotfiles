{ config, pkgs, lib, ... }:

{
    boot.loader.efi.canTouchEfiVariables = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    time.timeZone = "Europe/Warsaw";

    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "pl_PL.UTF-8";
        LC_IDENTIFICATION = "pl_PL.UTF-8";
        LC_MEASUREMENT = "pl_PL.UTF-8";
        LC_MONETARY = "pl_PL.UTF-8";
        LC_NAME = "pl_PL.UTF-8";
        LC_NUMERIC = "pl_PL.UTF-8";
        LC_PAPER = "pl_PL.UTF-8";
        LC_TELEPHONE = "pl_PL.UTF-8";
        LC_TIME = "pl_PL.UTF-8";
    };

    programs.zsh.enable = true;

    services.tailscale.enable = true;

    networking.firewall = {
        enable = true;
        allowedUDPPorts = [ config.services.tailscale.port ];
    };
}
