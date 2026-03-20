{ pkgs, inputs, lib, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disk.nix
    ../../users/g4ng
    ../../modules/davinci-resolve
    ../../modules/stylix
    ../../modules/misc/syncthing
  ];

  boot.loader.systemd-boot.enable             = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.timeout                         = 15;
  boot.loader.efi.canTouchEfiVariables        = true;
  boot.initrd.kernelModules                   = [ "amdgpu" ];

  services.displayManager.sddm.enable  = true;
  services.xserver.enable              = true;
  services.xserver.videoDrivers        = [ "amdgpu" ];

  sops.defaultSopsFile = ../../secrets/toledo.yaml;
  sops.age.keyFile     = "/etc/age/keys.txt";

  sops.secrets.wifi_psk  = {};
  sops.secrets.wifi_ssid = {};
  sops.secrets.static_ip = {};
  sops.secrets.gateway   = {};
  sops.secrets.dns       = {};
  sops.secrets.git_email = {};

  sops.templates.wifi-env = {
    content = ''
      WIFI_PSK=${config.sops.placeholder.wifi_psk}
      WIFI_SSID=${config.sops.placeholder.wifi_ssid}
      STATIC_IP=${config.sops.placeholder.static_ip}
      GATEWAY=${config.sops.placeholder.gateway}
      DNS=${config.sops.placeholder.dns}
    '';
    path = "/run/secrets/wifi-env";
  };

  sops.templates.gitconfig = {
    content = ''
      [user]
        email = ${config.sops.placeholder.git_email}
    '';
    path  = "/run/secrets/gitconfig";
    owner = "g4ng";
    mode  = "0400";
  };

  systemd.tmpfiles.rules = [
    "z /etc/age/keys.txt 0600 root root -"
  ];

  networking.hostName              = "toledo";
  networking.networkmanager.enable = true;
  networking.networkmanager.ensureProfiles = {
    environmentFiles = [ config.sops.templates.wifi-env.path ];
    profiles."home-wifi" = {
      connection = {
        id   = "$WIFI_SSID";
        type = "wifi";
      };
      wifi = {
        mode = "infrastructure";
        ssid = "$WIFI_SSID";
      };
      wifi-security = {
        auth-alg = "open";
        key-mgmt = "wpa-psk";
        psk      = "$WIFI_PSK";
      };
      ipv4 = {
        method   = "manual";
        address1 = "$STATIC_IP,$GATEWAY";
        dns      = "$DNS";
      };
      ipv6 = {
        method        = "auto";
        addr-gen-mode = "stable-privacy";
      };
    };
  };

  console.keyMap        = "us-acentos";
  i18n.defaultLocale    = "es_ES.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "es_ES.UTF-8/UTF-8"
  ];

  hardware.i2c.enable = true;

  environment.systemPackages = with pkgs; [
    ddcutil
    claude-code
    btop-rocm
    bitwarden-cli
    papirus-icon-theme
    xwayland-satellite
    mako
    fuzzel
    kdePackages.polkit-kde-agent-1
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    sunshine
    ffmpeg
    orca-slicer
    bitwarden-desktop
    obsidian
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
    jack.enable       = true;
  };

  programs.steam.enable   = true;
  programs.firefox.enable = true;
  programs.niri.enable    = true;

  xdg.portal = {
    enable       = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.gnome.gnome-keyring.enable           = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  programs.nix-ld.enable    = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    openssl
    curl
    glib
  ];

  misc.syncthing = {
    enable  = true;
    role    = "client";
    user    = "g4ng";
    dataDir = "/home/g4ng";
    overrideDevices = true;
    overrideFolders = false;
    devices = {
      proxmox = {
        id                = "ZDR47VZ-J2FNFSV-7XX6KQY-6EJDS6C-GA6XS4G-VBJH6XD-D4U27LT-X7CXRQX";
        autoAcceptFolders = false;
      };
    };
    folders = {
      "uzyxu-holdf" = {
        path    = "/home/g4ng/Documents/";
        devices = [ "proxmox" ];
        type    = "sendreceive";
      };
    };
  };

  # Sunshine game streaming
  networking.firewall.allowedTCPPorts = [ 47984 47989 48010 ];
  networking.firewall.allowedUDPPorts = [ 47998 47999 48000 48002 ];

  powerManagement.cpuFreqGovernor = "schedutil";

  home-manager = {
    useGlobalPkgs       = true;
    useUserPackages     = false;
    backupFileExtension = "backup";
    users.g4ng.imports  = [ ../../users/g4ng/dots.nix ];
  };
  
  system.stateVersion = "25.11";
}
