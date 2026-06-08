{ config, pkgs, lib, localDNSip, ... }:

{
    imports =
        [
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

    hardware.graphics.enable = true;
    hardware.nvidia.open = true;

    systemd.targets.sleep.enable = false;
    systemd.targets.suspend.enable = false;
    systemd.targets.hibernate.enable = false;
    systemd.targets.hybrid-sleep.enable = false;
    services.logind.enable = true;

    services.xserver = {
	enable = false;
	videoDrivers = [ "nvidia" ];
        xkb = {
            layout = "us";
            variant = "";
            options = "ctrl:nocaps";
        };
    };
    services.dbus = {
        enable = true;
        implementation = "broker";
    };
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraOptions = [ "--unsupported-gpu" ];
    };

    environment.sessionVariables = {
        WLR_NO_HARDWARE_CURSORS = "1"; # Prevents cursor invisibility on Nvidia
        NIXOS_OZONE_WL = "1";          # Hints Electron apps (like VSCode/Chromium) to run natively on Wayland
        XDG_CURRENT_DESKTOP = "sway";
        XDG_SESSION_TYPE = "wayland";
    };

    services.displayManager.ly = {
        enable = true;
        x11Support = true;
        settings = {
            bg = "0x2E3440";          # nord0
            fg = "0xD8DEE9";          # nord4

            input_bg = "0x3B4252";    # nord1
            input_fg = "0xE5E9F0";    # nord5

            border_fg = "0x81A1C1";   # nord9
            selection_bg = "0x88C0D0";
            selection_fg = "0x2E3440";

            error_fg = "0xBF616A";    # nord11

            bigclock = true;
        };
    };
    services.displayManager.defaultSession = "sway";

    services.displayManager.gdm.enable = false;
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

    programs.firefox.enable = true;

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
        neovim
        wget
	zsh
        git
        steam
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
