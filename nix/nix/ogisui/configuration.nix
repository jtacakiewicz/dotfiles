# Edit this configuration file to define what should be installed on
# your system.    Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, localDNSip, ... }:

{
    imports =
        [ # Include the results of the hardware scan.
            ./hardware-configuration.nix
        ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelParams = [ 
        "nvme_core.default_ps_max_latency_us=0"
        "pcie_aspm=off"
        "nvme_core.hmb_for_ssd=0"
        "nvme_core.set_min_log_size=0"
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = "ogisui"; 
    networking.nameservers = [ localDNSip ];
    # Enable networking
    networking.networkmanager = {
        enable = true;
        dns = "none";
        insertNameservers = [ localDNSip ];
    };

    # Set your time zone.
    time.timeZone = "Europe/Warsaw";

    # Select internationalisation properties.
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

    hardware.graphics.enable = true;
    hardware.nvidia.open = true;

    systemd.targets.sleep.enable = false;
    systemd.targets.suspend.enable = false;
    systemd.targets.hibernate.enable = false;
    systemd.targets.hybrid-sleep.enable = false;

    services.xserver = {
	enable = true;
	videoDrivers = [ "nvidia" ];
        xkb = {
            layout = "us";
            variant = "";
            options = "ctrl:nocaps";
        };
    };
    xdg.portal = {
        enable = true;
        wlr.enable = true;

        config.sway.default = [ "gtk"];
    };
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraOptions = [ "--unsupported-gpu" ];
    };

    environment.sessionVariables = {
        WLR_NO_HARDWARE_CURSORS = "1"; # Prevents cursor invisibility on Nvidia
        NIXOS_OZONE_WL = "1";          # Hints Electron apps (like VSCode/Chromium) to run natively on Wayland
    };


    # Login manager
    services.displayManager.gdm.enable = true;

    # Remove GNOME desktop manager
    services.desktopManager.gnome.enable = false;
    services.printing.enable = true;

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    users.users.jamjan = {
        isNormalUser = true;
        description = "jamjan";
        extraGroups = [ "networkmanager" "wheel" ];
	shell = pkgs.zsh;
    };

    # Install firefox.
    programs.firefox.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # $ nix search wget
    environment.systemPackages = with pkgs; [
        neovim
        wget
	zsh
        git
        steam
        tofi # app launcher
        yazi # file manager
    ];
    programs.zsh.enable = true;
    programs.steam.enable = true;
    programs.dconf.enable = true;

    services.tailscale.enable = true;
    networking.firewall = {
        enable=true;
        allowedUDPPorts = [ config.services.tailscale.port ];
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.05"; # Did you read the comment?

}
