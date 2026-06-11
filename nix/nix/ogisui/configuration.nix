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
        "video=DP-1:1920x1080@60"
        "video=HDMI-A-1:1920x1080@60"
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
    hardware.nvidia.modesetting.enable = true;
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
        package = pkgs.ly;
        x11Support = true;
        settings = {
            animation = "dur_file"; # "doom", "matrix", "colormix"
            animation_timeout_sec = 0;
            auth_fails = 3; 
            bg = "0x02000000";
            dur_file_path = "/etc/ly/example.dur";
            border_fg = "0x01FFFFFF";
            box_title = "null";
            clear_password = true;
            clock = "%B, %A %d @ %H:%M:%S";
            colormix_col1 = "0x08FF0000";
            colormix_col2 = "0x0800FF00";
            colormix_col3 = "0x080000FF";
            default_input = "password";
            error_bg = "0x02000000";
            error_fg = "0x01FF0000";
            fg = "0x01FFFFFF";
            hide_borders = true;
            hide_version_string = true;
            hide_key_hints = true;
            initial_info_text = "null"; # hostname
            lang = "en";
            load = true;
            margin_box_h = 0;
            margin_box_v = 0;
            min_refresh_delta = 100;
            save = true;
            text_in_center = false;
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
